/*
 *  This file is part of Netsukuku.
 *  (c) Copyright 2015 Luca Dionisi aka lukisi <luca.dionisi@gmail.com>
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
using zcd.ModRpc;

namespace Netsukuku
{
    namespace ModRpc
    {
        public interface INeighborhoodManagerStub : Object
        {
            public abstract void here_i_am(INeighborhoodNodeID my_id, string mac, string nic_addr) throws StubError, DeserializeError;
            public abstract void request_arc(INeighborhoodNodeID my_id, string mac, string nic_addr) throws NeighborhoodRequestArcError, StubError, DeserializeError;
            public abstract void expect_ping(int guid) throws NeighborhoodUnmanagedDeviceError, StubError, DeserializeError;
            public abstract void remove_arc(INeighborhoodNodeID my_id, string mac, string nic_addr) throws StubError, DeserializeError;
        }

        public interface IAddressManagerStub : Object
        {
            protected abstract unowned INeighborhoodManagerStub neighborhood_manager_getter();
            public INeighborhoodManagerStub neighborhood_manager {get {return neighborhood_manager_getter();}}
        }

        public IAddressManagerStub get_addr_tcp_client(string peer_address, uint16 peer_port)
        {
            return new AddressManagerTcpClientRootStub(peer_address, peer_port);
        }

        internal class AddressManagerTcpClientRootStub : Object, IAddressManagerStub, ITcpClientRootStub
        {
            private TcpClient client;
            private string peer_address;
            private uint16 peer_port;
            private bool hurry;
            private bool wait_reply;
            private NeighborhoodManagerRemote _neighborhood_manager;
            public AddressManagerTcpClientRootStub(string peer_address, uint16 peer_port)
            {
                this.peer_address = peer_address;
                this.peer_port = peer_port;
                client = tcp_client(peer_address, peer_port);
                hurry = false;
                wait_reply = true;
                _neighborhood_manager = new NeighborhoodManagerRemote(this.call);
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

            private string call(string m_name, Gee.List<string> arguments) throws ZCDError, StubError
            {
                if (hurry && !client.is_queue_empty())
                {
                    client = tcp_client(peer_address, peer_port);
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

        public IAddressManagerStub get_addr_unicast(string dev, uint16 port, UnicastID unicast_id, bool wait_reply)
        {
            return new AddressManagerUnicastRootStub(dev, port, unicast_id, wait_reply);
        }

        internal class AddressManagerUnicastRootStub : Object, IAddressManagerStub
        {
            private string s_unicast_id;
            private string dev;
            private uint16 port;
            private bool wait_reply;
            private NeighborhoodManagerRemote _neighborhood_manager;
            public AddressManagerUnicastRootStub(string dev, uint16 port, UnicastID unicast_id, bool wait_reply)
            {
                s_unicast_id = prepare_direct_object(unicast_id);
                this.dev = dev;
                this.port = port;
                this.wait_reply = wait_reply;
                _neighborhood_manager = new NeighborhoodManagerRemote(this.call);
            }

            protected unowned INeighborhoodManagerStub neighborhood_manager_getter()
            {
                return _neighborhood_manager;
            }

            private string call(string m_name, Gee.List<string> arguments) throws ZCDError, StubError
            {
                return call_unicast_udp(m_name, arguments, dev, port, s_unicast_id, wait_reply);
            }
        }

        public IAddressManagerStub get_addr_broadcast(string dev, uint16 port, BroadcastID broadcast_id, IAckCommunicator? notify_ack=null)
        {
            return new AddressManagerBroadcastRootStub(dev, port, broadcast_id, notify_ack);
        }

        internal class AddressManagerBroadcastRootStub : Object, IAddressManagerStub
        {
            private string s_broadcast_id;
            private string dev;
            private uint16 port;
            private IAckCommunicator? notify_ack;
            private NeighborhoodManagerRemote _neighborhood_manager;
            public AddressManagerBroadcastRootStub(string dev, uint16 port, BroadcastID broadcast_id, IAckCommunicator? notify_ack=null)
            {
                s_broadcast_id = prepare_direct_object(broadcast_id);
                this.dev = dev;
                this.port = port;
                this.notify_ack = notify_ack;
                _neighborhood_manager = new NeighborhoodManagerRemote(this.call);
            }

            protected unowned INeighborhoodManagerStub neighborhood_manager_getter()
            {
                return _neighborhood_manager;
            }

            private string call(string m_name, Gee.List<string> arguments) throws ZCDError, StubError
            {
                return call_broadcast_udp(m_name, arguments, dev, port, s_broadcast_id, notify_ack);
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
                    throw new DeserializeError.GENERIC(@"$(doing): unrecognized error $(error_domain_code) $(error_message)");
                }
                return;
            }

            public void expect_ping(int arg0) throws NeighborhoodUnmanagedDeviceError, StubError, DeserializeError
            {
                string m_name = "addr.neighborhood_manager.expect_ping";
                ArrayList<string> args = new ArrayList<string>();
                {
                    // serialize arg0 (int guid)
                    args.add(prepare_argument_int64(arg0));
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
                    if (error_domain_code == "NeighborhoodUnmanagedDeviceError.GENERIC")
                        throw new NeighborhoodUnmanagedDeviceError.GENERIC(error_message);
                    throw new DeserializeError.GENERIC(@"$(doing): unrecognized error $(error_domain_code) $(error_message)");
                }
                return;
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
                    throw new DeserializeError.GENERIC(@"$(doing): unrecognized error $(error_domain_code) $(error_message)");
                }
                return;
            }

        }

    }
}
