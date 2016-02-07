/*
 *  This file is part of Netsukuku.
 *  (c) Copyright 2015-2016 Luca Dionisi aka lukisi <luca.dionisi@gmail.com>
 *
 *  Netsukuku is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  Netsukuku is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Netsukuku.  If not, see <http://www.gnu.org/licenses/>.
 */

using Gee;
using zcd;

namespace Netsukuku
{
        public interface INeighborhoodManagerStub : Object
        {
            public abstract void here_i_am(INeighborhoodNodeID my_id, string mac, string nic_addr) throws StubError, DeserializeError;
            public abstract void request_arc(INeighborhoodNodeID my_id, string mac, string nic_addr) throws NeighborhoodRequestArcError, StubError, DeserializeError;
            public abstract uint16 expect_ping(string guid, uint16 peer_port) throws NeighborhoodUnmanagedDeviceError, StubError, DeserializeError;
            public abstract void remove_arc(INeighborhoodNodeID my_id, string mac, string nic_addr) throws StubError, DeserializeError;
            public abstract void nop() throws StubError, DeserializeError;
        }

        public interface IQspnManagerStub : Object
        {
            public abstract IQspnEtpMessage get_full_etp(IQspnAddress requesting_address) throws QspnNotAcceptedError, QspnBootstrapInProgressError, StubError, DeserializeError;
            public abstract void send_etp(IQspnEtpMessage etp, bool is_full) throws QspnNotAcceptedError, StubError, DeserializeError;
        }

        public interface IPeersManagerStub : Object
        {
            public abstract IPeerParticipantSet get_participant_set(int lvl) throws PeersInvalidRequest, StubError, DeserializeError;
            public abstract void forward_peer_message(IPeerMessage peer_message) throws StubError, DeserializeError;
            public abstract IPeersRequest get_request(int msg_id, IPeerTupleNode respondant) throws PeersUnknownMessageError, PeersInvalidRequest, StubError, DeserializeError;
            public abstract void set_response(int msg_id, IPeersResponse response, IPeerTupleNode respondant) throws StubError, DeserializeError;
            public abstract void set_refuse_message(int msg_id, string refuse_message, IPeerTupleNode respondant) throws StubError, DeserializeError;
            public abstract void set_redo_from_start(int msg_id, IPeerTupleNode respondant) throws StubError, DeserializeError;
            public abstract void set_next_destination(int msg_id, IPeerTupleGNode tuple) throws StubError, DeserializeError;
            public abstract void set_failure(int msg_id, IPeerTupleGNode tuple) throws StubError, DeserializeError;
            public abstract void set_non_participant(int msg_id, IPeerTupleGNode tuple) throws StubError, DeserializeError;
            public abstract void set_participant(int p_id, IPeerTupleGNode tuple) throws StubError, DeserializeError;
        }

        public interface ICoordinatorManagerStub : Object
        {
            public abstract ICoordinatorNeighborMapMessage retrieve_neighbor_map() throws CoordinatorNodeNotReadyError, StubError, DeserializeError;
            public abstract ICoordinatorReservationMessage ask_reservation(int lvl) throws CoordinatorNodeNotReadyError, CoordinatorInvalidLevelError, CoordinatorSaturatedGnodeError, StubError, DeserializeError;
        }

        public interface IAddressManagerStub : Object
        {
            protected abstract unowned INeighborhoodManagerStub neighborhood_manager_getter();
            public INeighborhoodManagerStub neighborhood_manager {get {return neighborhood_manager_getter();}}
            protected abstract unowned IQspnManagerStub qspn_manager_getter();
            public IQspnManagerStub qspn_manager {get {return qspn_manager_getter();}}
            protected abstract unowned IPeersManagerStub peers_manager_getter();
            public IPeersManagerStub peers_manager {get {return peers_manager_getter();}}
            protected abstract unowned ICoordinatorManagerStub coordinator_manager_getter();
            public ICoordinatorManagerStub coordinator_manager {get {return coordinator_manager_getter();}}
        }

        public IAddressManagerStub get_addr_tcp_client(string peer_address, uint16 peer_port, ISourceID source_id, IUnicastID unicast_id)
        {
            return new AddressManagerTcpClientRootStub(peer_address, peer_port, source_id, unicast_id);
        }

        internal class AddressManagerTcpClientRootStub : Object, IAddressManagerStub, ITcpClientRootStub
        {
            private TcpClient client;
            private string peer_address;
            private uint16 peer_port;
            private string s_source_id;
            private string s_unicast_id;
            private bool hurry;
            private bool wait_reply;
            private NeighborhoodManagerRemote _neighborhood_manager;
            private QspnManagerRemote _qspn_manager;
            private PeersManagerRemote _peers_manager;
            private CoordinatorManagerRemote _coordinator_manager;
            public AddressManagerTcpClientRootStub(string peer_address, uint16 peer_port, ISourceID source_id, IUnicastID unicast_id)
            {
                this.peer_address = peer_address;
                this.peer_port = peer_port;
                s_source_id = prepare_direct_object(source_id);
                s_unicast_id = prepare_direct_object(unicast_id);
                client = tcp_client(peer_address, peer_port, s_source_id, s_unicast_id);
                hurry = false;
                wait_reply = true;
                _neighborhood_manager = new NeighborhoodManagerRemote(this.call);
                _qspn_manager = new QspnManagerRemote(this.call);
                _peers_manager = new PeersManagerRemote(this.call);
                _coordinator_manager = new CoordinatorManagerRemote(this.call);
            }

            public bool hurry_getter()
            {
                return hurry;
            }

            public void hurry_setter(bool new_value)
            {
                hurry = new_value;
            }

            public bool wait_reply_getter()
            {
                return wait_reply;
            }

            public void wait_reply_setter(bool new_value)
            {
                wait_reply = new_value;
            }

            protected unowned INeighborhoodManagerStub neighborhood_manager_getter()
            {
                return _neighborhood_manager;
            }

            protected unowned IQspnManagerStub qspn_manager_getter()
            {
                return _qspn_manager;
            }

            protected unowned IPeersManagerStub peers_manager_getter()
            {
                return _peers_manager;
            }

            protected unowned ICoordinatorManagerStub coordinator_manager_getter()
            {
                return _coordinator_manager;
            }

            private string call(string m_name, Gee.List<string> arguments) throws ZCDError, StubError
            {
                if (hurry && !client.is_queue_empty())
                {
                    client = tcp_client(peer_address, peer_port, s_source_id, s_unicast_id);
                }
                // TODO See destructor of TcpClient. If the low level library ZCD is able to ensure
                //  that the destructor is not called when a call is in progress, then this
                //  local_reference is not needed.
                TcpClient local_reference = client;
                string ret = local_reference.enqueue_call(m_name, arguments, wait_reply);
                if (!wait_reply) throw new StubError.DID_NOT_WAIT_REPLY(@"Didn't wait reply for a call to $(m_name)");
                return ret;
            }
        }

        public IAddressManagerStub get_addr_unicast(string dev, uint16 port, ISourceID source_id, IUnicastID unicast_id, bool wait_reply)
        {
            return new AddressManagerUnicastRootStub(dev, port, source_id, unicast_id, wait_reply);
        }

        internal class AddressManagerUnicastRootStub : Object, IAddressManagerStub
        {
            private string s_source_id;
            private string s_unicast_id;
            private string dev;
            private uint16 port;
            private bool wait_reply;
            private NeighborhoodManagerRemote _neighborhood_manager;
            private QspnManagerRemote _qspn_manager;
            private PeersManagerRemote _peers_manager;
            private CoordinatorManagerRemote _coordinator_manager;
            public AddressManagerUnicastRootStub(string dev, uint16 port, ISourceID source_id, IUnicastID unicast_id, bool wait_reply)
            {
                s_source_id = prepare_direct_object(source_id);
                s_unicast_id = prepare_direct_object(unicast_id);
                this.dev = dev;
                this.port = port;
                this.wait_reply = wait_reply;
                _neighborhood_manager = new NeighborhoodManagerRemote(this.call);
                _qspn_manager = new QspnManagerRemote(this.call);
                _peers_manager = new PeersManagerRemote(this.call);
                _coordinator_manager = new CoordinatorManagerRemote(this.call);
            }

            protected unowned INeighborhoodManagerStub neighborhood_manager_getter()
            {
                return _neighborhood_manager;
            }

            protected unowned IQspnManagerStub qspn_manager_getter()
            {
                return _qspn_manager;
            }

            protected unowned IPeersManagerStub peers_manager_getter()
            {
                return _peers_manager;
            }

            protected unowned ICoordinatorManagerStub coordinator_manager_getter()
            {
                return _coordinator_manager;
            }

            private string call(string m_name, Gee.List<string> arguments) throws ZCDError, StubError
            {
                return call_unicast_udp(m_name, arguments, dev, port, s_source_id, s_unicast_id, wait_reply);
            }
        }

        public IAddressManagerStub get_addr_broadcast
        (Gee.Collection<string> devs, uint16 port, ISourceID source_id, IBroadcastID broadcast_id, IAckCommunicator? notify_ack=null)
        {
            return new AddressManagerBroadcastRootStub(devs, port, source_id, broadcast_id, notify_ack);
        }

        internal class AddressManagerBroadcastRootStub : Object, IAddressManagerStub
        {
            private string s_source_id;
            private string s_broadcast_id;
            private Gee.Collection<string> devs;
            private uint16 port;
            private IAckCommunicator? notify_ack;
            private NeighborhoodManagerRemote _neighborhood_manager;
            private QspnManagerRemote _qspn_manager;
            private PeersManagerRemote _peers_manager;
            private CoordinatorManagerRemote _coordinator_manager;
            public AddressManagerBroadcastRootStub
            (Gee.Collection<string> devs, uint16 port, ISourceID source_id, IBroadcastID broadcast_id, IAckCommunicator? notify_ack=null)
            {
                s_source_id = prepare_direct_object(source_id);
                s_broadcast_id = prepare_direct_object(broadcast_id);
                this.devs = new ArrayList<string>();
                this.devs.add_all(devs);
                this.port = port;
                this.notify_ack = notify_ack;
                _neighborhood_manager = new NeighborhoodManagerRemote(this.call);
                _qspn_manager = new QspnManagerRemote(this.call);
                _peers_manager = new PeersManagerRemote(this.call);
                _coordinator_manager = new CoordinatorManagerRemote(this.call);
            }

            protected unowned INeighborhoodManagerStub neighborhood_manager_getter()
            {
                return _neighborhood_manager;
            }

            protected unowned IQspnManagerStub qspn_manager_getter()
            {
                return _qspn_manager;
            }

            protected unowned IPeersManagerStub peers_manager_getter()
            {
                return _peers_manager;
            }

            protected unowned ICoordinatorManagerStub coordinator_manager_getter()
            {
                return _coordinator_manager;
            }

            private string call(string m_name, Gee.List<string> arguments) throws ZCDError, StubError
            {
                return call_broadcast_udp(m_name, arguments, devs, port, s_source_id, s_broadcast_id, notify_ack);
            }
        }

        internal class NeighborhoodManagerRemote : Object, INeighborhoodManagerStub
        {
            private unowned FakeRmt rmt;
            public NeighborhoodManagerRemote(FakeRmt rmt)
            {
                this.rmt = rmt;
            }

            public void here_i_am(INeighborhoodNodeID arg0, string arg1, string arg2) throws StubError, DeserializeError
            {
                string m_name = "addr.neighborhood_manager.here_i_am";
                ArrayList<string> args = new ArrayList<string>();
                {
                    // serialize arg0 (INeighborhoodNodeID my_id)
                    args.add(prepare_argument_object(arg0));
                }
                {
                    // serialize arg1 (string mac)
                    args.add(prepare_argument_string(arg1));
                }
                {
                    // serialize arg2 (string nic_addr)
                    args.add(prepare_argument_string(arg2));
                }

                string resp;
                try {
                    resp = rmt(m_name, args);
                }
                catch (ZCDError e) {
                    throw new StubError.GENERIC(e.message);
                }
                // The following catch is to be added only for methods that return void.
                catch (StubError.DID_NOT_WAIT_REPLY e) {return;}

                // deserialize response
                string? error_domain = null;
                string? error_code = null;
                string? error_message = null;
                string doing = @"Reading return-value of $(m_name)";
                try {
                    read_return_value_void(resp, out error_domain, out error_code, out error_message);
                } catch (HelperNotJsonError e) {
                    error(@"Error parsing JSON for return-value of $(m_name): $(e.message)");
                } catch (HelperDeserializeError e) {
                    throw new DeserializeError.GENERIC(@"$(doing): $(e.message)");
                }
                if (error_domain != null)
                {
                    string error_domain_code = @"$(error_domain).$(error_code)";
                    if (error_domain_code == "DeserializeError.GENERIC")
                        throw new DeserializeError.GENERIC(error_message);
                    throw new DeserializeError.GENERIC(@"$(doing): unrecognized error $(error_domain_code) $(error_message)");
                }
                return;
            }

            public void request_arc(INeighborhoodNodeID arg0, string arg1, string arg2) throws NeighborhoodRequestArcError, StubError, DeserializeError
            {
                string m_name = "addr.neighborhood_manager.request_arc";
                ArrayList<string> args = new ArrayList<string>();
                {
                    // serialize arg0 (INeighborhoodNodeID my_id)
                    args.add(prepare_argument_object(arg0));
                }
                {
                    // serialize arg1 (string mac)
                    args.add(prepare_argument_string(arg1));
                }
                {
                    // serialize arg2 (string nic_addr)
                    args.add(prepare_argument_string(arg2));
                }

                string resp;
                try {
                    resp = rmt(m_name, args);
                }
                catch (ZCDError e) {
                    throw new StubError.GENERIC(e.message);
                }
                // The following catch is to be added only for methods that return void.
                catch (StubError.DID_NOT_WAIT_REPLY e) {return;}

                // deserialize response
                string? error_domain = null;
                string? error_code = null;
                string? error_message = null;
                string doing = @"Reading return-value of $(m_name)";
                try {
                    read_return_value_void(resp, out error_domain, out error_code, out error_message);
                } catch (HelperNotJsonError e) {
                    error(@"Error parsing JSON for return-value of $(m_name): $(e.message)");
                } catch (HelperDeserializeError e) {
                    throw new DeserializeError.GENERIC(@"$(doing): $(e.message)");
                }
                if (error_domain != null)
                {
                    string error_domain_code = @"$(error_domain).$(error_code)";
                    if (error_domain_code == "NeighborhoodRequestArcError.NOT_SAME_NETWORK")
                        throw new NeighborhoodRequestArcError.NOT_SAME_NETWORK(error_message);
                    if (error_domain_code == "NeighborhoodRequestArcError.TOO_MANY_ARCS")
                        throw new NeighborhoodRequestArcError.TOO_MANY_ARCS(error_message);
                    if (error_domain_code == "NeighborhoodRequestArcError.TWO_ARCS_ON_COLLISION_DOMAIN")
                        throw new NeighborhoodRequestArcError.TWO_ARCS_ON_COLLISION_DOMAIN(error_message);
                    if (error_domain_code == "NeighborhoodRequestArcError.GENERIC")
                        throw new NeighborhoodRequestArcError.GENERIC(error_message);
                    if (error_domain_code == "DeserializeError.GENERIC")
                        throw new DeserializeError.GENERIC(error_message);
                    throw new DeserializeError.GENERIC(@"$(doing): unrecognized error $(error_domain_code) $(error_message)");
                }
                return;
            }

            public uint16 expect_ping(string arg0, uint16 arg1) throws NeighborhoodUnmanagedDeviceError, StubError, DeserializeError
            {
                string m_name = "addr.neighborhood_manager.expect_ping";
                ArrayList<string> args = new ArrayList<string>();
                {
                    // serialize arg0 (string guid)
                    args.add(prepare_argument_string(arg0));
                }
                {
                    // serialize arg1 (uint16 peer_port)
                    args.add(prepare_argument_int64(arg1));
                }

                string resp;
                try {
                    resp = rmt(m_name, args);
                }
                catch (ZCDError e) {
                    throw new StubError.GENERIC(e.message);
                }

                // deserialize response
                string? error_domain = null;
                string? error_code = null;
                string? error_message = null;
                string doing = @"Reading return-value of $(m_name)";
                uint16 ret;
                int64 val;
                try {
                    val = read_return_value_int64_notnull(resp, out error_domain, out error_code, out error_message);
                } catch (HelperNotJsonError e) {
                    error(@"Error parsing JSON for return-value of $(m_name): $(e.message)");
                } catch (HelperDeserializeError e) {
                    throw new DeserializeError.GENERIC(@"$(doing): $(e.message)");
                }
                if (error_domain != null)
                {
                    string error_domain_code = @"$(error_domain).$(error_code)";
                    if (error_domain_code == "NeighborhoodUnmanagedDeviceError.GENERIC")
                        throw new NeighborhoodUnmanagedDeviceError.GENERIC(error_message);
                    if (error_domain_code == "DeserializeError.GENERIC")
                        throw new DeserializeError.GENERIC(error_message);
                    throw new DeserializeError.GENERIC(@"$(doing): unrecognized error $(error_domain_code) $(error_message)");
                }
                if (val > uint16.MAX || val < uint16.MIN)
                    throw new DeserializeError.GENERIC(@"$(doing): return-value overflows size of uint16");
                ret = (uint16)val;
                return ret;
            }

            public void remove_arc(INeighborhoodNodeID arg0, string arg1, string arg2) throws StubError, DeserializeError
            {
                string m_name = "addr.neighborhood_manager.remove_arc";
                ArrayList<string> args = new ArrayList<string>();
                {
                    // serialize arg0 (INeighborhoodNodeID my_id)
                    args.add(prepare_argument_object(arg0));
                }
                {
                    // serialize arg1 (string mac)
                    args.add(prepare_argument_string(arg1));
                }
                {
                    // serialize arg2 (string nic_addr)
                    args.add(prepare_argument_string(arg2));
                }

                string resp;
                try {
                    resp = rmt(m_name, args);
                }
                catch (ZCDError e) {
                    throw new StubError.GENERIC(e.message);
                }
                // The following catch is to be added only for methods that return void.
                catch (StubError.DID_NOT_WAIT_REPLY e) {return;}

                // deserialize response
                string? error_domain = null;
                string? error_code = null;
                string? error_message = null;
                string doing = @"Reading return-value of $(m_name)";
                try {
                    read_return_value_void(resp, out error_domain, out error_code, out error_message);
                } catch (HelperNotJsonError e) {
                    error(@"Error parsing JSON for return-value of $(m_name): $(e.message)");
                } catch (HelperDeserializeError e) {
                    throw new DeserializeError.GENERIC(@"$(doing): $(e.message)");
                }
                if (error_domain != null)
                {
                    string error_domain_code = @"$(error_domain).$(error_code)";
                    if (error_domain_code == "DeserializeError.GENERIC")
                        throw new DeserializeError.GENERIC(error_message);
                    throw new DeserializeError.GENERIC(@"$(doing): unrecognized error $(error_domain_code) $(error_message)");
                }
                return;
            }

            public void nop() throws StubError, DeserializeError
            {
                string m_name = "addr.neighborhood_manager.nop";
                ArrayList<string> args = new ArrayList<string>();

                string resp;
                try {
                    resp = rmt(m_name, args);
                }
                catch (ZCDError e) {
                    throw new StubError.GENERIC(e.message);
                }
                // The following catch is to be added only for methods that return void.
                catch (StubError.DID_NOT_WAIT_REPLY e) {return;}

                // deserialize response
                string? error_domain = null;
                string? error_code = null;
                string? error_message = null;
                string doing = @"Reading return-value of $(m_name)";
                try {
                    read_return_value_void(resp, out error_domain, out error_code, out error_message);
                } catch (HelperNotJsonError e) {
                    error(@"Error parsing JSON for return-value of $(m_name): $(e.message)");
                } catch (HelperDeserializeError e) {
                    throw new DeserializeError.GENERIC(@"$(doing): $(e.message)");
                }
                if (error_domain != null)
                {
                    string error_domain_code = @"$(error_domain).$(error_code)";
                    if (error_domain_code == "DeserializeError.GENERIC")
                        throw new DeserializeError.GENERIC(error_message);
                    throw new DeserializeError.GENERIC(@"$(doing): unrecognized error $(error_domain_code) $(error_message)");
                }
                return;
            }

        }

        internal class QspnManagerRemote : Object, IQspnManagerStub
        {
            private unowned FakeRmt rmt;
            public QspnManagerRemote(FakeRmt rmt)
            {
                this.rmt = rmt;
            }

            public IQspnEtpMessage get_full_etp(IQspnAddress arg0) throws QspnNotAcceptedError, QspnBootstrapInProgressError, StubError, DeserializeError
            {
                string m_name = "addr.qspn_manager.get_full_etp";
                ArrayList<string> args = new ArrayList<string>();
                {
                    // serialize arg0 (IQspnAddress requesting_address)
                    args.add(prepare_argument_object(arg0));
                }

                string resp;
                try {
                    resp = rmt(m_name, args);
                }
                catch (ZCDError e) {
                    throw new StubError.GENERIC(e.message);
                }

                // deserialize response
                string? error_domain = null;
                string? error_code = null;
                string? error_message = null;
                string doing = @"Reading return-value of $(m_name)";
                Object ret;
                try {
                    ret = read_return_value_object_notnull(typeof(IQspnEtpMessage), resp, out error_domain, out error_code, out error_message);
                } catch (HelperNotJsonError e) {
                    error(@"Error parsing JSON for return-value of $(m_name): $(e.message)");
                } catch (HelperDeserializeError e) {
                    throw new DeserializeError.GENERIC(@"$(doing): $(e.message)");
                }
                if (error_domain != null)
                {
                    string error_domain_code = @"$(error_domain).$(error_code)";
                    if (error_domain_code == "QspnNotAcceptedError.GENERIC")
                        throw new QspnNotAcceptedError.GENERIC(error_message);
                    if (error_domain_code == "QspnBootstrapInProgressError.GENERIC")
                        throw new QspnBootstrapInProgressError.GENERIC(error_message);
                    if (error_domain_code == "DeserializeError.GENERIC")
                        throw new DeserializeError.GENERIC(error_message);
                    throw new DeserializeError.GENERIC(@"$(doing): unrecognized error $(error_domain_code) $(error_message)");
                }
                if (ret is ISerializable)
                    if (!((ISerializable)ret).check_deserialization())
                        throw new DeserializeError.GENERIC(@"$(doing): instance of $(ret.get_type().name()) has not been fully deserialized");
                return (IQspnEtpMessage)ret;
            }

            public void send_etp(IQspnEtpMessage arg0, bool arg1) throws QspnNotAcceptedError, StubError, DeserializeError
            {
                string m_name = "addr.qspn_manager.send_etp";
                ArrayList<string> args = new ArrayList<string>();
                {
                    // serialize arg0 (IQspnEtpMessage etp)
                    args.add(prepare_argument_object(arg0));
                }
                {
                    // serialize arg1 (bool is_full)
                    args.add(prepare_argument_boolean(arg1));
                }

                string resp;
                try {
                    resp = rmt(m_name, args);
                }
                catch (ZCDError e) {
                    throw new StubError.GENERIC(e.message);
                }
                // The following catch is to be added only for methods that return void.
                catch (StubError.DID_NOT_WAIT_REPLY e) {return;}

                // deserialize response
                string? error_domain = null;
                string? error_code = null;
                string? error_message = null;
                string doing = @"Reading return-value of $(m_name)";
                try {
                    read_return_value_void(resp, out error_domain, out error_code, out error_message);
                } catch (HelperNotJsonError e) {
                    error(@"Error parsing JSON for return-value of $(m_name): $(e.message)");
                } catch (HelperDeserializeError e) {
                    throw new DeserializeError.GENERIC(@"$(doing): $(e.message)");
                }
                if (error_domain != null)
                {
                    string error_domain_code = @"$(error_domain).$(error_code)";
                    if (error_domain_code == "QspnNotAcceptedError.GENERIC")
                        throw new QspnNotAcceptedError.GENERIC(error_message);
                    if (error_domain_code == "DeserializeError.GENERIC")
                        throw new DeserializeError.GENERIC(error_message);
                    throw new DeserializeError.GENERIC(@"$(doing): unrecognized error $(error_domain_code) $(error_message)");
                }
                return;
            }

        }

        internal class PeersManagerRemote : Object, IPeersManagerStub
        {
            private unowned FakeRmt rmt;
            public PeersManagerRemote(FakeRmt rmt)
            {
                this.rmt = rmt;
            }

            public IPeerParticipantSet get_participant_set(int arg0) throws PeersInvalidRequest, StubError, DeserializeError
            {
                string m_name = "addr.peers_manager.get_participant_set";
                ArrayList<string> args = new ArrayList<string>();
                {
                    // serialize arg0 (int lvl)
                    args.add(prepare_argument_int64(arg0));
                }

                string resp;
                try {
                    resp = rmt(m_name, args);
                }
                catch (ZCDError e) {
                    throw new StubError.GENERIC(e.message);
                }

                // deserialize response
                string? error_domain = null;
                string? error_code = null;
                string? error_message = null;
                string doing = @"Reading return-value of $(m_name)";
                Object ret;
                try {
                    ret = read_return_value_object_notnull(typeof(IPeerParticipantSet), resp, out error_domain, out error_code, out error_message);
                } catch (HelperNotJsonError e) {
                    error(@"Error parsing JSON for return-value of $(m_name): $(e.message)");
                } catch (HelperDeserializeError e) {
                    throw new DeserializeError.GENERIC(@"$(doing): $(e.message)");
                }
                if (error_domain != null)
                {
                    string error_domain_code = @"$(error_domain).$(error_code)";
                    if (error_domain_code == "PeersInvalidRequest.GENERIC")
                        throw new PeersInvalidRequest.GENERIC(error_message);
                    if (error_domain_code == "DeserializeError.GENERIC")
                        throw new DeserializeError.GENERIC(error_message);
                    throw new DeserializeError.GENERIC(@"$(doing): unrecognized error $(error_domain_code) $(error_message)");
                }
                if (ret is ISerializable)
                    if (!((ISerializable)ret).check_deserialization())
                        throw new DeserializeError.GENERIC(@"$(doing): instance of $(ret.get_type().name()) has not been fully deserialized");
                return (IPeerParticipantSet)ret;
            }

            public void forward_peer_message(IPeerMessage arg0) throws StubError, DeserializeError
            {
                string m_name = "addr.peers_manager.forward_peer_message";
                ArrayList<string> args = new ArrayList<string>();
                {
                    // serialize arg0 (IPeerMessage peer_message)
                    args.add(prepare_argument_object(arg0));
                }

                string resp;
                try {
                    resp = rmt(m_name, args);
                }
                catch (ZCDError e) {
                    throw new StubError.GENERIC(e.message);
                }
                // The following catch is to be added only for methods that return void.
                catch (StubError.DID_NOT_WAIT_REPLY e) {return;}

                // deserialize response
                string? error_domain = null;
                string? error_code = null;
                string? error_message = null;
                string doing = @"Reading return-value of $(m_name)";
                try {
                    read_return_value_void(resp, out error_domain, out error_code, out error_message);
                } catch (HelperNotJsonError e) {
                    error(@"Error parsing JSON for return-value of $(m_name): $(e.message)");
                } catch (HelperDeserializeError e) {
                    throw new DeserializeError.GENERIC(@"$(doing): $(e.message)");
                }
                if (error_domain != null)
                {
                    string error_domain_code = @"$(error_domain).$(error_code)";
                    if (error_domain_code == "DeserializeError.GENERIC")
                        throw new DeserializeError.GENERIC(error_message);
                    throw new DeserializeError.GENERIC(@"$(doing): unrecognized error $(error_domain_code) $(error_message)");
                }
                return;
            }

            public IPeersRequest get_request(int arg0, IPeerTupleNode arg1) throws PeersUnknownMessageError, PeersInvalidRequest, StubError, DeserializeError
            {
                string m_name = "addr.peers_manager.get_request";
                ArrayList<string> args = new ArrayList<string>();
                {
                    // serialize arg0 (int msg_id)
                    args.add(prepare_argument_int64(arg0));
                }
                {
                    // serialize arg1 (IPeerTupleNode respondant)
                    args.add(prepare_argument_object(arg1));
                }

                string resp;
                try {
                    resp = rmt(m_name, args);
                }
                catch (ZCDError e) {
                    throw new StubError.GENERIC(e.message);
                }

                // deserialize response
                string? error_domain = null;
                string? error_code = null;
                string? error_message = null;
                string doing = @"Reading return-value of $(m_name)";
                Object ret;
                try {
                    ret = read_return_value_object_notnull(typeof(IPeersRequest), resp, out error_domain, out error_code, out error_message);
                } catch (HelperNotJsonError e) {
                    error(@"Error parsing JSON for return-value of $(m_name): $(e.message)");
                } catch (HelperDeserializeError e) {
                    throw new DeserializeError.GENERIC(@"$(doing): $(e.message)");
                }
                if (error_domain != null)
                {
                    string error_domain_code = @"$(error_domain).$(error_code)";
                    if (error_domain_code == "PeersUnknownMessageError.GENERIC")
                        throw new PeersUnknownMessageError.GENERIC(error_message);
                    if (error_domain_code == "PeersInvalidRequest.GENERIC")
                        throw new PeersInvalidRequest.GENERIC(error_message);
                    if (error_domain_code == "DeserializeError.GENERIC")
                        throw new DeserializeError.GENERIC(error_message);
                    throw new DeserializeError.GENERIC(@"$(doing): unrecognized error $(error_domain_code) $(error_message)");
                }
                if (ret is ISerializable)
                    if (!((ISerializable)ret).check_deserialization())
                        throw new DeserializeError.GENERIC(@"$(doing): instance of $(ret.get_type().name()) has not been fully deserialized");
                return (IPeersRequest)ret;
            }

            public void set_response(int arg0, IPeersResponse arg1, IPeerTupleNode arg2) throws StubError, DeserializeError
            {
                string m_name = "addr.peers_manager.set_response";
                ArrayList<string> args = new ArrayList<string>();
                {
                    // serialize arg0 (int msg_id)
                    args.add(prepare_argument_int64(arg0));
                }
                {
                    // serialize arg1 (IPeersResponse response)
                    args.add(prepare_argument_object(arg1));
                }
                {
                    // serialize arg2 (IPeerTupleNode respondant)
                    args.add(prepare_argument_object(arg2));
                }

                string resp;
                try {
                    resp = rmt(m_name, args);
                }
                catch (ZCDError e) {
                    throw new StubError.GENERIC(e.message);
                }
                // The following catch is to be added only for methods that return void.
                catch (StubError.DID_NOT_WAIT_REPLY e) {return;}

                // deserialize response
                string? error_domain = null;
                string? error_code = null;
                string? error_message = null;
                string doing = @"Reading return-value of $(m_name)";
                try {
                    read_return_value_void(resp, out error_domain, out error_code, out error_message);
                } catch (HelperNotJsonError e) {
                    error(@"Error parsing JSON for return-value of $(m_name): $(e.message)");
                } catch (HelperDeserializeError e) {
                    throw new DeserializeError.GENERIC(@"$(doing): $(e.message)");
                }
                if (error_domain != null)
                {
                    string error_domain_code = @"$(error_domain).$(error_code)";
                    if (error_domain_code == "DeserializeError.GENERIC")
                        throw new DeserializeError.GENERIC(error_message);
                    throw new DeserializeError.GENERIC(@"$(doing): unrecognized error $(error_domain_code) $(error_message)");
                }
                return;
            }

            public void set_refuse_message(int arg0, string arg1, IPeerTupleNode arg2) throws StubError, DeserializeError
            {
                string m_name = "addr.peers_manager.set_refuse_message";
                ArrayList<string> args = new ArrayList<string>();
                {
                    // serialize arg0 (int msg_id)
                    args.add(prepare_argument_int64(arg0));
                }
                {
                    // serialize arg1 (string refuse_message)
                    args.add(prepare_argument_string(arg1));
                }
                {
                    // serialize arg2 (IPeerTupleNode respondant)
                    args.add(prepare_argument_object(arg2));
                }

                string resp;
                try {
                    resp = rmt(m_name, args);
                }
                catch (ZCDError e) {
                    throw new StubError.GENERIC(e.message);
                }
                // The following catch is to be added only for methods that return void.
                catch (StubError.DID_NOT_WAIT_REPLY e) {return;}

                // deserialize response
                string? error_domain = null;
                string? error_code = null;
                string? error_message = null;
                string doing = @"Reading return-value of $(m_name)";
                try {
                    read_return_value_void(resp, out error_domain, out error_code, out error_message);
                } catch (HelperNotJsonError e) {
                    error(@"Error parsing JSON for return-value of $(m_name): $(e.message)");
                } catch (HelperDeserializeError e) {
                    throw new DeserializeError.GENERIC(@"$(doing): $(e.message)");
                }
                if (error_domain != null)
                {
                    string error_domain_code = @"$(error_domain).$(error_code)";
                    if (error_domain_code == "DeserializeError.GENERIC")
                        throw new DeserializeError.GENERIC(error_message);
                    throw new DeserializeError.GENERIC(@"$(doing): unrecognized error $(error_domain_code) $(error_message)");
                }
                return;
            }

            public void set_redo_from_start(int arg0, IPeerTupleNode arg1) throws StubError, DeserializeError
            {
                string m_name = "addr.peers_manager.set_redo_from_start";
                ArrayList<string> args = new ArrayList<string>();
                {
                    // serialize arg0 (int msg_id)
                    args.add(prepare_argument_int64(arg0));
                }
                {
                    // serialize arg1 (IPeerTupleNode respondant)
                    args.add(prepare_argument_object(arg1));
                }

                string resp;
                try {
                    resp = rmt(m_name, args);
                }
                catch (ZCDError e) {
                    throw new StubError.GENERIC(e.message);
                }
                // The following catch is to be added only for methods that return void.
                catch (StubError.DID_NOT_WAIT_REPLY e) {return;}

                // deserialize response
                string? error_domain = null;
                string? error_code = null;
                string? error_message = null;
                string doing = @"Reading return-value of $(m_name)";
                try {
                    read_return_value_void(resp, out error_domain, out error_code, out error_message);
                } catch (HelperNotJsonError e) {
                    error(@"Error parsing JSON for return-value of $(m_name): $(e.message)");
                } catch (HelperDeserializeError e) {
                    throw new DeserializeError.GENERIC(@"$(doing): $(e.message)");
                }
                if (error_domain != null)
                {
                    string error_domain_code = @"$(error_domain).$(error_code)";
                    if (error_domain_code == "DeserializeError.GENERIC")
                        throw new DeserializeError.GENERIC(error_message);
                    throw new DeserializeError.GENERIC(@"$(doing): unrecognized error $(error_domain_code) $(error_message)");
                }
                return;
            }

            public void set_next_destination(int arg0, IPeerTupleGNode arg1) throws StubError, DeserializeError
            {
                string m_name = "addr.peers_manager.set_next_destination";
                ArrayList<string> args = new ArrayList<string>();
                {
                    // serialize arg0 (int msg_id)
                    args.add(prepare_argument_int64(arg0));
                }
                {
                    // serialize arg1 (IPeerTupleGNode tuple)
                    args.add(prepare_argument_object(arg1));
                }

                string resp;
                try {
                    resp = rmt(m_name, args);
                }
                catch (ZCDError e) {
                    throw new StubError.GENERIC(e.message);
                }
                // The following catch is to be added only for methods that return void.
                catch (StubError.DID_NOT_WAIT_REPLY e) {return;}

                // deserialize response
                string? error_domain = null;
                string? error_code = null;
                string? error_message = null;
                string doing = @"Reading return-value of $(m_name)";
                try {
                    read_return_value_void(resp, out error_domain, out error_code, out error_message);
                } catch (HelperNotJsonError e) {
                    error(@"Error parsing JSON for return-value of $(m_name): $(e.message)");
                } catch (HelperDeserializeError e) {
                    throw new DeserializeError.GENERIC(@"$(doing): $(e.message)");
                }
                if (error_domain != null)
                {
                    string error_domain_code = @"$(error_domain).$(error_code)";
                    if (error_domain_code == "DeserializeError.GENERIC")
                        throw new DeserializeError.GENERIC(error_message);
                    throw new DeserializeError.GENERIC(@"$(doing): unrecognized error $(error_domain_code) $(error_message)");
                }
                return;
            }

            public void set_failure(int arg0, IPeerTupleGNode arg1) throws StubError, DeserializeError
            {
                string m_name = "addr.peers_manager.set_failure";
                ArrayList<string> args = new ArrayList<string>();
                {
                    // serialize arg0 (int msg_id)
                    args.add(prepare_argument_int64(arg0));
                }
                {
                    // serialize arg1 (IPeerTupleGNode tuple)
                    args.add(prepare_argument_object(arg1));
                }

                string resp;
                try {
                    resp = rmt(m_name, args);
                }
                catch (ZCDError e) {
                    throw new StubError.GENERIC(e.message);
                }
                // The following catch is to be added only for methods that return void.
                catch (StubError.DID_NOT_WAIT_REPLY e) {return;}

                // deserialize response
                string? error_domain = null;
                string? error_code = null;
                string? error_message = null;
                string doing = @"Reading return-value of $(m_name)";
                try {
                    read_return_value_void(resp, out error_domain, out error_code, out error_message);
                } catch (HelperNotJsonError e) {
                    error(@"Error parsing JSON for return-value of $(m_name): $(e.message)");
                } catch (HelperDeserializeError e) {
                    throw new DeserializeError.GENERIC(@"$(doing): $(e.message)");
                }
                if (error_domain != null)
                {
                    string error_domain_code = @"$(error_domain).$(error_code)";
                    if (error_domain_code == "DeserializeError.GENERIC")
                        throw new DeserializeError.GENERIC(error_message);
                    throw new DeserializeError.GENERIC(@"$(doing): unrecognized error $(error_domain_code) $(error_message)");
                }
                return;
            }

            public void set_non_participant(int arg0, IPeerTupleGNode arg1) throws StubError, DeserializeError
            {
                string m_name = "addr.peers_manager.set_non_participant";
                ArrayList<string> args = new ArrayList<string>();
                {
                    // serialize arg0 (int msg_id)
                    args.add(prepare_argument_int64(arg0));
                }
                {
                    // serialize arg1 (IPeerTupleGNode tuple)
                    args.add(prepare_argument_object(arg1));
                }

                string resp;
                try {
                    resp = rmt(m_name, args);
                }
                catch (ZCDError e) {
                    throw new StubError.GENERIC(e.message);
                }
                // The following catch is to be added only for methods that return void.
                catch (StubError.DID_NOT_WAIT_REPLY e) {return;}

                // deserialize response
                string? error_domain = null;
                string? error_code = null;
                string? error_message = null;
                string doing = @"Reading return-value of $(m_name)";
                try {
                    read_return_value_void(resp, out error_domain, out error_code, out error_message);
                } catch (HelperNotJsonError e) {
                    error(@"Error parsing JSON for return-value of $(m_name): $(e.message)");
                } catch (HelperDeserializeError e) {
                    throw new DeserializeError.GENERIC(@"$(doing): $(e.message)");
                }
                if (error_domain != null)
                {
                    string error_domain_code = @"$(error_domain).$(error_code)";
                    if (error_domain_code == "DeserializeError.GENERIC")
                        throw new DeserializeError.GENERIC(error_message);
                    throw new DeserializeError.GENERIC(@"$(doing): unrecognized error $(error_domain_code) $(error_message)");
                }
                return;
            }

            public void set_participant(int arg0, IPeerTupleGNode arg1) throws StubError, DeserializeError
            {
                string m_name = "addr.peers_manager.set_participant";
                ArrayList<string> args = new ArrayList<string>();
                {
                    // serialize arg0 (int p_id)
                    args.add(prepare_argument_int64(arg0));
                }
                {
                    // serialize arg1 (IPeerTupleGNode tuple)
                    args.add(prepare_argument_object(arg1));
                }

                string resp;
                try {
                    resp = rmt(m_name, args);
                }
                catch (ZCDError e) {
                    throw new StubError.GENERIC(e.message);
                }
                // The following catch is to be added only for methods that return void.
                catch (StubError.DID_NOT_WAIT_REPLY e) {return;}

                // deserialize response
                string? error_domain = null;
                string? error_code = null;
                string? error_message = null;
                string doing = @"Reading return-value of $(m_name)";
                try {
                    read_return_value_void(resp, out error_domain, out error_code, out error_message);
                } catch (HelperNotJsonError e) {
                    error(@"Error parsing JSON for return-value of $(m_name): $(e.message)");
                } catch (HelperDeserializeError e) {
                    throw new DeserializeError.GENERIC(@"$(doing): $(e.message)");
                }
                if (error_domain != null)
                {
                    string error_domain_code = @"$(error_domain).$(error_code)";
                    if (error_domain_code == "DeserializeError.GENERIC")
                        throw new DeserializeError.GENERIC(error_message);
                    throw new DeserializeError.GENERIC(@"$(doing): unrecognized error $(error_domain_code) $(error_message)");
                }
                return;
            }

        }

        internal class CoordinatorManagerRemote : Object, ICoordinatorManagerStub
        {
            private unowned FakeRmt rmt;
            public CoordinatorManagerRemote(FakeRmt rmt)
            {
                this.rmt = rmt;
            }

            public ICoordinatorNeighborMapMessage retrieve_neighbor_map() throws CoordinatorNodeNotReadyError, StubError, DeserializeError
            {
                string m_name = "addr.coordinator_manager.retrieve_neighbor_map";
                ArrayList<string> args = new ArrayList<string>();

                string resp;
                try {
                    resp = rmt(m_name, args);
                }
                catch (ZCDError e) {
                    throw new StubError.GENERIC(e.message);
                }

                // deserialize response
                string? error_domain = null;
                string? error_code = null;
                string? error_message = null;
                string doing = @"Reading return-value of $(m_name)";
                Object ret;
                try {
                    ret = read_return_value_object_notnull(typeof(ICoordinatorNeighborMapMessage), resp, out error_domain, out error_code, out error_message);
                } catch (HelperNotJsonError e) {
                    error(@"Error parsing JSON for return-value of $(m_name): $(e.message)");
                } catch (HelperDeserializeError e) {
                    throw new DeserializeError.GENERIC(@"$(doing): $(e.message)");
                }
                if (error_domain != null)
                {
                    string error_domain_code = @"$(error_domain).$(error_code)";
                    if (error_domain_code == "CoordinatorNodeNotReadyError.GENERIC")
                        throw new CoordinatorNodeNotReadyError.GENERIC(error_message);
                    if (error_domain_code == "DeserializeError.GENERIC")
                        throw new DeserializeError.GENERIC(error_message);
                    throw new DeserializeError.GENERIC(@"$(doing): unrecognized error $(error_domain_code) $(error_message)");
                }
                if (ret is ISerializable)
                    if (!((ISerializable)ret).check_deserialization())
                        throw new DeserializeError.GENERIC(@"$(doing): instance of $(ret.get_type().name()) has not been fully deserialized");
                return (ICoordinatorNeighborMapMessage)ret;
            }

            public ICoordinatorReservationMessage ask_reservation(int arg0) throws CoordinatorNodeNotReadyError, CoordinatorInvalidLevelError, CoordinatorSaturatedGnodeError, StubError, DeserializeError
            {
                string m_name = "addr.coordinator_manager.ask_reservation";
                ArrayList<string> args = new ArrayList<string>();
                {
                    // serialize arg0 (int lvl)
                    args.add(prepare_argument_int64(arg0));
                }

                string resp;
                try {
                    resp = rmt(m_name, args);
                }
                catch (ZCDError e) {
                    throw new StubError.GENERIC(e.message);
                }

                // deserialize response
                string? error_domain = null;
                string? error_code = null;
                string? error_message = null;
                string doing = @"Reading return-value of $(m_name)";
                Object ret;
                try {
                    ret = read_return_value_object_notnull(typeof(ICoordinatorReservationMessage), resp, out error_domain, out error_code, out error_message);
                } catch (HelperNotJsonError e) {
                    error(@"Error parsing JSON for return-value of $(m_name): $(e.message)");
                } catch (HelperDeserializeError e) {
                    throw new DeserializeError.GENERIC(@"$(doing): $(e.message)");
                }
                if (error_domain != null)
                {
                    string error_domain_code = @"$(error_domain).$(error_code)";
                    if (error_domain_code == "CoordinatorNodeNotReadyError.GENERIC")
                        throw new CoordinatorNodeNotReadyError.GENERIC(error_message);
                    if (error_domain_code == "CoordinatorInvalidLevelError.GENERIC")
                        throw new CoordinatorInvalidLevelError.GENERIC(error_message);
                    if (error_domain_code == "CoordinatorSaturatedGnodeError.GENERIC")
                        throw new CoordinatorSaturatedGnodeError.GENERIC(error_message);
                    if (error_domain_code == "DeserializeError.GENERIC")
                        throw new DeserializeError.GENERIC(error_message);
                    throw new DeserializeError.GENERIC(@"$(doing): unrecognized error $(error_domain_code) $(error_message)");
                }
                if (ret is ISerializable)
                    if (!((ISerializable)ret).check_deserialization())
                        throw new DeserializeError.GENERIC(@"$(doing): instance of $(ret.get_type().name()) has not been fully deserialized");
                return (ICoordinatorReservationMessage)ret;
            }

        }

}
