/*
 *  This file is part of Netsukuku.
 *  (c) Copyright 2018 Luca Dionisi aka lukisi <luca.dionisi@gmail.com>
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
using TaskletSystem;

namespace Netsukuku
{
    public interface INeighborhoodManagerStub : Object
    {
        public abstract void here_i_am(INeighborhoodNodeIDMessage my_id, string my_mac, string my_nic_addr) throws StubError, DeserializeError;
        public abstract void request_arc(INeighborhoodNodeIDMessage your_id, string your_mac, string your_nic_addr, INeighborhoodNodeIDMessage my_id, string my_mac, string my_nic_addr) throws StubError, DeserializeError;
        public abstract bool can_you_export(bool i_can_export) throws StubError, DeserializeError;
        public abstract void remove_arc(INeighborhoodNodeIDMessage your_id, string your_mac, string your_nic_addr, INeighborhoodNodeIDMessage my_id, string my_mac, string my_nic_addr) throws StubError, DeserializeError;
        public abstract void nop() throws StubError, DeserializeError;
    }

    public interface IIdentityManagerStub : Object
    {
        public abstract IDuplicationData? match_duplication(int migration_id, IIdentityID peer_id, IIdentityID old_id, IIdentityID new_id, string old_id_new_mac, string old_id_new_linklocal) throws StubError, DeserializeError;
        public abstract IIdentityID get_peer_main_id() throws StubError, DeserializeError;
        public abstract void notify_identity_arc_removed(IIdentityID peer_id, IIdentityID my_id) throws StubError, DeserializeError;
    }

    public interface IQspnManagerStub : Object
    {
        public abstract IQspnEtpMessage get_full_etp(IQspnAddress requesting_address) throws QspnNotAcceptedError, QspnBootstrapInProgressError, StubError, DeserializeError;
        public abstract void send_etp(IQspnEtpMessage etp, bool is_full) throws QspnNotAcceptedError, StubError, DeserializeError;
        public abstract void got_prepare_destroy() throws StubError, DeserializeError;
        public abstract void got_destroy() throws StubError, DeserializeError;
    }

    public interface IPeersManagerStub : Object
    {
        public abstract void forward_peer_message(IPeerMessage peer_message) throws StubError, DeserializeError;
        public abstract IPeersRequest get_request(int msg_id, IPeerTupleNode respondant) throws PeersUnknownMessageError, PeersInvalidRequest, StubError, DeserializeError;
        public abstract void set_response(int msg_id, IPeersResponse response, IPeerTupleNode respondant) throws StubError, DeserializeError;
        public abstract void set_refuse_message(int msg_id, string refuse_message, int e_lvl, IPeerTupleNode respondant) throws StubError, DeserializeError;
        public abstract void set_redo_from_start(int msg_id, IPeerTupleNode respondant) throws StubError, DeserializeError;
        public abstract void set_next_destination(int msg_id, IPeerTupleGNode tuple) throws StubError, DeserializeError;
        public abstract void set_failure(int msg_id, IPeerTupleGNode tuple) throws StubError, DeserializeError;
        public abstract void set_non_participant(int msg_id, IPeerTupleGNode tuple) throws StubError, DeserializeError;
        public abstract void set_missing_optional_maps(int msg_id) throws StubError, DeserializeError;
        public abstract void set_participant(int p_id, IPeerTupleGNode tuple) throws StubError, DeserializeError;
        public abstract void give_participant_maps(IPeerParticipantSet maps) throws StubError, DeserializeError;
        public abstract IPeerParticipantSet ask_participant_maps() throws StubError, DeserializeError;
    }

    public interface ICoordinatorManagerStub : Object
    {
        public abstract void execute_prepare_migration(ICoordTupleGNode tuple, int64 fp_id, int propagation_id, int lvl, ICoordObject prepare_migration_data) throws StubError, DeserializeError;
        public abstract void execute_finish_migration(ICoordTupleGNode tuple, int64 fp_id, int propagation_id, int lvl, ICoordObject finish_migration_data) throws StubError, DeserializeError;
        public abstract void execute_prepare_enter(ICoordTupleGNode tuple, int64 fp_id, int propagation_id, int lvl, ICoordObject prepare_enter_data) throws StubError, DeserializeError;
        public abstract void execute_finish_enter(ICoordTupleGNode tuple, int64 fp_id, int propagation_id, int lvl, ICoordObject finish_enter_data) throws StubError, DeserializeError;
        public abstract void execute_we_have_splitted(ICoordTupleGNode tuple, int64 fp_id, int propagation_id, int lvl, ICoordObject we_have_splitted_data) throws StubError, DeserializeError;
    }

    public interface IHookingManagerStub : Object
    {
        public abstract INetworkData retrieve_network_data(bool ask_coord) throws HookingNotPrincipalError, NotBoostrappedError, StubError, DeserializeError;
        public abstract IEntryData search_migration_path(int lvl) throws NoMigrationPathFoundError, MigrationPathExecuteFailureError, NotBoostrappedError, StubError, DeserializeError;
        public abstract void route_search_request(ISearchMigrationPathRequest p0) throws StubError, DeserializeError;
        public abstract void route_search_error(ISearchMigrationPathErrorPkt p2) throws StubError, DeserializeError;
        public abstract void route_search_response(ISearchMigrationPathResponse p1) throws StubError, DeserializeError;
        public abstract void route_explore_request(IExploreGNodeRequest p0) throws StubError, DeserializeError;
        public abstract void route_explore_response(IExploreGNodeResponse p1) throws StubError, DeserializeError;
        public abstract void route_delete_reserve_request(IDeleteReservationRequest p0) throws StubError, DeserializeError;
        public abstract void route_mig_request(IRequestPacket p0) throws StubError, DeserializeError;
        public abstract void route_mig_response(IResponsePacket p1) throws StubError, DeserializeError;
    }

    public interface IAddressManagerStub : Object
    {
        protected abstract unowned INeighborhoodManagerStub neighborhood_manager_getter();
        public INeighborhoodManagerStub neighborhood_manager {get {return neighborhood_manager_getter();}}
        protected abstract unowned IIdentityManagerStub identity_manager_getter();
        public IIdentityManagerStub identity_manager {get {return identity_manager_getter();}}
        protected abstract unowned IQspnManagerStub qspn_manager_getter();
        public IQspnManagerStub qspn_manager {get {return qspn_manager_getter();}}
        protected abstract unowned IPeersManagerStub peers_manager_getter();
        public IPeersManagerStub peers_manager {get {return peers_manager_getter();}}
        protected abstract unowned ICoordinatorManagerStub coordinator_manager_getter();
        public ICoordinatorManagerStub coordinator_manager {get {return coordinator_manager_getter();}}
        protected abstract unowned IHookingManagerStub hooking_manager_getter();
        public IHookingManagerStub hooking_manager {get {return hooking_manager_getter();}}
    }

    public IAddressManagerStub get_addr_stream_net(
        string peer_ip, uint16 tcp_port,
        ISourceID source_id, IUnicastID unicast_id, ISrcNic src_nic,
        bool wait_reply)
    {
        return new StreamNetAddressManagerStub(peer_ip, tcp_port,
            source_id, unicast_id, src_nic,
            wait_reply);
    }

    public IAddressManagerStub get_addr_stream_system(
        string send_pathname,
        ISourceID source_id, IUnicastID unicast_id, ISrcNic src_nic,
        bool wait_reply)
    {
        return new StreamSystemAddressManagerStub(send_pathname,
            source_id, unicast_id, src_nic,
            wait_reply);
    }

    public IAddressManagerStub get_addr_datagram_net(
        string my_dev, uint16 udp_port,
        ISourceID source_id, IBroadcastID broadcast_id, ISrcNic src_nic,
        IAckCommunicator? notify_ack=null)
    {
        return new DatagramNetAddressManagerStub(my_dev, udp_port,
            source_id, broadcast_id, src_nic,
            notify_ack);
    }

    public IAddressManagerStub get_addr_datagram_system(
        string send_pathname,
        ISourceID source_id, IBroadcastID broadcast_id, ISrcNic src_nic,
        IAckCommunicator? notify_ack=null)
    {
        return new DatagramSystemAddressManagerStub(send_pathname,
            source_id, broadcast_id, src_nic,
            notify_ack);
    }

    internal class StreamNetAddressManagerStub : Object, IAddressManagerStub
    {
        private string s_source_id;
        private string s_unicast_id;
        private string s_src_nic;
        private string peer_ip;
        private uint16 tcp_port;
        private bool wait_reply;
        private NeighborhoodManagerRemote _neighborhood_manager;
        private IdentityManagerRemote _identity_manager;
        private QspnManagerRemote _qspn_manager;
        private PeersManagerRemote _peers_manager;
        private CoordinatorManagerRemote _coordinator_manager;
        private HookingManagerRemote _hooking_manager;
        public StreamNetAddressManagerStub(
            string peer_ip, uint16 tcp_port,
            ISourceID source_id, IUnicastID unicast_id, ISrcNic src_nic,
            bool wait_reply)
        {
            s_source_id = prepare_direct_object(source_id);
            s_unicast_id = prepare_direct_object(unicast_id);
            s_src_nic = prepare_direct_object(src_nic);
            this.peer_ip = peer_ip;
            this.tcp_port = tcp_port;
            this.wait_reply = wait_reply;
            _neighborhood_manager = new NeighborhoodManagerRemote(this.call);
            _identity_manager = new IdentityManagerRemote(this.call);
            _qspn_manager = new QspnManagerRemote(this.call);
            _peers_manager = new PeersManagerRemote(this.call);
            _coordinator_manager = new CoordinatorManagerRemote(this.call);
            _hooking_manager = new HookingManagerRemote(this.call);
        }

        protected unowned INeighborhoodManagerStub neighborhood_manager_getter()
        {
            return _neighborhood_manager;
        }

        protected unowned IIdentityManagerStub identity_manager_getter()
        {
            return _identity_manager;
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

        protected unowned IHookingManagerStub hooking_manager_getter()
        {
            return _hooking_manager;
        }

        private string call(string m_name, Gee.List<string> arguments) throws zcd.ZCDError, StubError
        {
            string ret =
                zcd.send_stream_net(
                peer_ip, tcp_port,
                s_source_id, s_src_nic, s_unicast_id, m_name, arguments,
                wait_reply);
            if (!wait_reply) throw new StubError.DID_NOT_WAIT_REPLY(@"Didn't wait reply for a call to $(m_name)");
            return ret;
        }
    }

    internal class StreamSystemAddressManagerStub : Object, IAddressManagerStub
    {
        private string s_source_id;
        private string s_unicast_id;
        private string s_src_nic;
        private string send_pathname;
        private bool wait_reply;
        private NeighborhoodManagerRemote _neighborhood_manager;
        private IdentityManagerRemote _identity_manager;
        private QspnManagerRemote _qspn_manager;
        private PeersManagerRemote _peers_manager;
        private CoordinatorManagerRemote _coordinator_manager;
        private HookingManagerRemote _hooking_manager;
        public StreamSystemAddressManagerStub(
            string send_pathname,
            ISourceID source_id, IUnicastID unicast_id, ISrcNic src_nic,
            bool wait_reply)
        {
            s_source_id = prepare_direct_object(source_id);
            s_unicast_id = prepare_direct_object(unicast_id);
            s_src_nic = prepare_direct_object(src_nic);
            this.send_pathname = send_pathname;
            this.wait_reply = wait_reply;
            _neighborhood_manager = new NeighborhoodManagerRemote(this.call);
            _identity_manager = new IdentityManagerRemote(this.call);
            _qspn_manager = new QspnManagerRemote(this.call);
            _peers_manager = new PeersManagerRemote(this.call);
            _coordinator_manager = new CoordinatorManagerRemote(this.call);
            _hooking_manager = new HookingManagerRemote(this.call);
        }

        protected unowned INeighborhoodManagerStub neighborhood_manager_getter()
        {
            return _neighborhood_manager;
        }

        protected unowned IIdentityManagerStub identity_manager_getter()
        {
            return _identity_manager;
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

        protected unowned IHookingManagerStub hooking_manager_getter()
        {
            return _hooking_manager;
        }

        private string call(string m_name, Gee.List<string> arguments) throws zcd.ZCDError, StubError
        {
            string ret =
                zcd.send_stream_system(
                send_pathname,
                s_source_id, s_src_nic, s_unicast_id, m_name, arguments,
                wait_reply);
            if (!wait_reply) throw new StubError.DID_NOT_WAIT_REPLY(@"Didn't wait reply for a call to $(m_name)");
            return ret;
        }
    }

    internal class DatagramNetAddressManagerStub : Object, IAddressManagerStub
    {
        private string s_source_id;
        private string s_broadcast_id;
        private string s_src_nic;
        private string my_dev;
        private uint16 udp_port;
        private IAckCommunicator? notify_ack;
        private NeighborhoodManagerRemote _neighborhood_manager;
        private IdentityManagerRemote _identity_manager;
        private QspnManagerRemote _qspn_manager;
        private PeersManagerRemote _peers_manager;
        private CoordinatorManagerRemote _coordinator_manager;
        private HookingManagerRemote _hooking_manager;
        public DatagramNetAddressManagerStub(
            string my_dev, uint16 udp_port,
            ISourceID source_id, IBroadcastID broadcast_id, ISrcNic src_nic,
            IAckCommunicator? notify_ack=null)
        {
            s_source_id = prepare_direct_object(source_id);
            s_broadcast_id = prepare_direct_object(broadcast_id);
            s_src_nic = prepare_direct_object(src_nic);
            this.my_dev = my_dev;
            this.udp_port = udp_port;
            this.notify_ack = notify_ack;
            _neighborhood_manager = new NeighborhoodManagerRemote(this.call);
            _identity_manager = new IdentityManagerRemote(this.call);
            _qspn_manager = new QspnManagerRemote(this.call);
            _peers_manager = new PeersManagerRemote(this.call);
            _coordinator_manager = new CoordinatorManagerRemote(this.call);
            _hooking_manager = new HookingManagerRemote(this.call);
        }

        protected unowned INeighborhoodManagerStub neighborhood_manager_getter()
        {
            return _neighborhood_manager;
        }

        protected unowned IIdentityManagerStub identity_manager_getter()
        {
            return _identity_manager;
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

        protected unowned IHookingManagerStub hooking_manager_getter()
        {
            return _hooking_manager;
        }

        private string call(string m_name, Gee.List<string> arguments) throws zcd.ZCDError, StubError
        {
            IChannel ch = tasklet.get_channel();
            int packet_id = Random.int_range(0, int.MAX);
            string k_map = @"$(my_dev):$(udp_port)";

            if (notify_ack != null)
            {
                assert(map_datagram_listening != null && map_datagram_listening.has_key(k_map));
                DatagramDelegate datagram_dlg = map_datagram_listening[k_map];
                datagram_dlg.going_to_send_broadcast_with_ack(packet_id, ch);
            }
            else
            {
                if (map_datagram_listening != null && map_datagram_listening.has_key(k_map))
                {
                    DatagramDelegate datagram_dlg = map_datagram_listening[k_map];
                    datagram_dlg.going_to_send_broadcast_no_ack(packet_id);
                }
            }

            zcd.send_datagram_net(
                my_dev, udp_port,
                packet_id,
                s_source_id, s_src_nic, s_broadcast_id, m_name, arguments,
                notify_ack!=null);

            if (notify_ack != null)  // and no error was thrown before...
            {
                tasklet.spawn(new NotifyAckTasklet(notify_ack, ch));
            }
            // This implementation of FakeRmt will never return a value.
            throw new StubError.DID_NOT_WAIT_REPLY(@"Didn't wait reply for a call to $(m_name)");
        }
    }

    internal class DatagramSystemAddressManagerStub : Object, IAddressManagerStub
    {
        private string s_source_id;
        private string s_broadcast_id;
        private string s_src_nic;
        private string send_pathname;
        private IAckCommunicator? notify_ack;
        private NeighborhoodManagerRemote _neighborhood_manager;
        private IdentityManagerRemote _identity_manager;
        private QspnManagerRemote _qspn_manager;
        private PeersManagerRemote _peers_manager;
        private CoordinatorManagerRemote _coordinator_manager;
        private HookingManagerRemote _hooking_manager;
        public DatagramSystemAddressManagerStub(
            string send_pathname,
            ISourceID source_id, IBroadcastID broadcast_id, ISrcNic src_nic,
            IAckCommunicator? notify_ack=null)
        {
            s_source_id = prepare_direct_object(source_id);
            s_broadcast_id = prepare_direct_object(broadcast_id);
            s_src_nic = prepare_direct_object(src_nic);
            this.send_pathname = send_pathname;
            this.notify_ack = notify_ack;
            _neighborhood_manager = new NeighborhoodManagerRemote(this.call);
            _identity_manager = new IdentityManagerRemote(this.call);
            _qspn_manager = new QspnManagerRemote(this.call);
            _peers_manager = new PeersManagerRemote(this.call);
            _coordinator_manager = new CoordinatorManagerRemote(this.call);
            _hooking_manager = new HookingManagerRemote(this.call);
        }

        protected unowned INeighborhoodManagerStub neighborhood_manager_getter()
        {
            return _neighborhood_manager;
        }

        protected unowned IIdentityManagerStub identity_manager_getter()
        {
            return _identity_manager;
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

        protected unowned IHookingManagerStub hooking_manager_getter()
        {
            return _hooking_manager;
        }

        private string call(string m_name, Gee.List<string> arguments) throws zcd.ZCDError, StubError
        {
            IChannel ch = tasklet.get_channel();
            int packet_id = Random.int_range(0, int.MAX);
            string k_map = @"$(send_pathname)";

            if (notify_ack != null)
            {
                assert(map_datagram_listening != null && map_datagram_listening.has_key(k_map));
                DatagramDelegate datagram_dlg = map_datagram_listening[k_map];
                datagram_dlg.going_to_send_broadcast_with_ack(packet_id, ch);
            }
            else
            {
                if (map_datagram_listening != null && map_datagram_listening.has_key(k_map))
                {
                    DatagramDelegate datagram_dlg = map_datagram_listening[k_map];
                    datagram_dlg.going_to_send_broadcast_no_ack(packet_id);
                }
            }

            zcd.send_datagram_system(
                send_pathname,
                packet_id,
                s_source_id, s_src_nic, s_broadcast_id, m_name, arguments,
                notify_ack!=null);

            if (notify_ack != null)  // and no error was thrown before...
            {
                tasklet.spawn(new NotifyAckTasklet(notify_ack, ch));
            }
            // This implementation of FakeRmt will never return a value.
            throw new StubError.DID_NOT_WAIT_REPLY(@"Didn't wait reply for a call to $(m_name)");
        }
    }

    internal class NeighborhoodManagerRemote : Object, INeighborhoodManagerStub
    {
        private unowned FakeRmt rmt;
        public NeighborhoodManagerRemote(FakeRmt rmt)
        {
            this.rmt = rmt;
        }

        public void here_i_am(INeighborhoodNodeIDMessage arg0, string arg1, string arg2) throws StubError, DeserializeError
        {
            string m_name = "addr.neighborhood_manager.here_i_am";
            ArrayList<string> args = new ArrayList<string>();
            {
                // serialize arg0 (INeighborhoodNodeIDMessage my_id)
                args.add(prepare_argument_object(arg0));
            }
            {
                // serialize arg1 (string my_mac)
                args.add(prepare_argument_string(arg1));
            }
            {
                // serialize arg2 (string my_nic_addr)
                args.add(prepare_argument_string(arg2));
            }

            string resp;
            try {
                resp = rmt(m_name, args);
            }
            catch (zcd.ZCDError e) {
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


        public void request_arc(INeighborhoodNodeIDMessage arg0, string arg1, string arg2, INeighborhoodNodeIDMessage arg3, string arg4, string arg5) throws StubError, DeserializeError
        {
            string m_name = "addr.neighborhood_manager.request_arc";
            ArrayList<string> args = new ArrayList<string>();
            {
                // serialize arg0 (INeighborhoodNodeIDMessage your_id)
                args.add(prepare_argument_object(arg0));
            }
            {
                // serialize arg1 (string your_mac)
                args.add(prepare_argument_string(arg1));
            }
            {
                // serialize arg2 (string your_nic_addr)
                args.add(prepare_argument_string(arg2));
            }
            {
                // serialize arg3 (INeighborhoodNodeIDMessage my_id)
                args.add(prepare_argument_object(arg3));
            }
            {
                // serialize arg4 (string my_mac)
                args.add(prepare_argument_string(arg4));
            }
            {
                // serialize arg5 (string my_nic_addr)
                args.add(prepare_argument_string(arg5));
            }

            string resp;
            try {
                resp = rmt(m_name, args);
            }
            catch (zcd.ZCDError e) {
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


        public bool can_you_export(bool arg0) throws StubError, DeserializeError
        {
            string m_name = "addr.neighborhood_manager.can_you_export";
            ArrayList<string> args = new ArrayList<string>();
            {
                // serialize arg0 (bool i_can_export)
                args.add(prepare_argument_boolean(arg0));
            }

            string resp;
            try {
                resp = rmt(m_name, args);
            }
            catch (zcd.ZCDError e) {
                throw new StubError.GENERIC(e.message);
            }

            // deserialize response
            string? error_domain = null;
            string? error_code = null;
            string? error_message = null;
            string doing = @"Reading return-value of $(m_name)";
            bool ret;
            try {
                ret = read_return_value_bool_notnull(resp, out error_domain, out error_code, out error_message);
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
            return ret;
        }


        public void remove_arc(INeighborhoodNodeIDMessage arg0, string arg1, string arg2, INeighborhoodNodeIDMessage arg3, string arg4, string arg5) throws StubError, DeserializeError
        {
            string m_name = "addr.neighborhood_manager.remove_arc";
            ArrayList<string> args = new ArrayList<string>();
            {
                // serialize arg0 (INeighborhoodNodeIDMessage your_id)
                args.add(prepare_argument_object(arg0));
            }
            {
                // serialize arg1 (string your_mac)
                args.add(prepare_argument_string(arg1));
            }
            {
                // serialize arg2 (string your_nic_addr)
                args.add(prepare_argument_string(arg2));
            }
            {
                // serialize arg3 (INeighborhoodNodeIDMessage my_id)
                args.add(prepare_argument_object(arg3));
            }
            {
                // serialize arg4 (string my_mac)
                args.add(prepare_argument_string(arg4));
            }
            {
                // serialize arg5 (string my_nic_addr)
                args.add(prepare_argument_string(arg5));
            }

            string resp;
            try {
                resp = rmt(m_name, args);
            }
            catch (zcd.ZCDError e) {
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
            catch (zcd.ZCDError e) {
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

    internal class IdentityManagerRemote : Object, IIdentityManagerStub
    {
        private unowned FakeRmt rmt;
        public IdentityManagerRemote(FakeRmt rmt)
        {
            this.rmt = rmt;
        }

        public IDuplicationData? match_duplication(int arg0, IIdentityID arg1, IIdentityID arg2, IIdentityID arg3, string arg4, string arg5) throws StubError, DeserializeError
        {
            string m_name = "addr.identity_manager.match_duplication";
            ArrayList<string> args = new ArrayList<string>();
            {
                // serialize arg0 (int migration_id)
                args.add(prepare_argument_int64(arg0));
            }
            {
                // serialize arg1 (IIdentityID peer_id)
                args.add(prepare_argument_object(arg1));
            }
            {
                // serialize arg2 (IIdentityID old_id)
                args.add(prepare_argument_object(arg2));
            }
            {
                // serialize arg3 (IIdentityID new_id)
                args.add(prepare_argument_object(arg3));
            }
            {
                // serialize arg4 (string old_id_new_mac)
                args.add(prepare_argument_string(arg4));
            }
            {
                // serialize arg5 (string old_id_new_linklocal)
                args.add(prepare_argument_string(arg5));
            }

            string resp;
            try {
                resp = rmt(m_name, args);
            }
            catch (zcd.ZCDError e) {
                throw new StubError.GENERIC(e.message);
            }

            // deserialize response
            string? error_domain = null;
            string? error_code = null;
            string? error_message = null;
            string doing = @"Reading return-value of $(m_name)";
            Object? ret;
            try {
                ret = read_return_value_object_maybe(typeof(IDuplicationData), resp, out error_domain, out error_code, out error_message);
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
            if (ret == null) return null;
            if (ret is ISerializable)
                if (!((ISerializable)ret).check_deserialization())
                    throw new DeserializeError.GENERIC(@"$(doing): instance of $(ret.get_type().name()) has not been fully deserialized");
            return (IDuplicationData)ret;
        }


        public IIdentityID get_peer_main_id() throws StubError, DeserializeError
        {
            string m_name = "addr.identity_manager.get_peer_main_id";
            ArrayList<string> args = new ArrayList<string>();

            string resp;
            try {
                resp = rmt(m_name, args);
            }
            catch (zcd.ZCDError e) {
                throw new StubError.GENERIC(e.message);
            }

            // deserialize response
            string? error_domain = null;
            string? error_code = null;
            string? error_message = null;
            string doing = @"Reading return-value of $(m_name)";
            Object ret;
            try {
                ret = read_return_value_object_notnull(typeof(IIdentityID), resp, out error_domain, out error_code, out error_message);
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
            if (ret is ISerializable)
                if (!((ISerializable)ret).check_deserialization())
                    throw new DeserializeError.GENERIC(@"$(doing): instance of $(ret.get_type().name()) has not been fully deserialized");
            return (IIdentityID)ret;
        }


        public void notify_identity_arc_removed(IIdentityID arg0, IIdentityID arg1) throws StubError, DeserializeError
        {
            string m_name = "addr.identity_manager.notify_identity_arc_removed";
            ArrayList<string> args = new ArrayList<string>();
            {
                // serialize arg0 (IIdentityID peer_id)
                args.add(prepare_argument_object(arg0));
            }
            {
                // serialize arg1 (IIdentityID my_id)
                args.add(prepare_argument_object(arg1));
            }

            string resp;
            try {
                resp = rmt(m_name, args);
            }
            catch (zcd.ZCDError e) {
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
            catch (zcd.ZCDError e) {
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
            catch (zcd.ZCDError e) {
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


        public void got_prepare_destroy() throws StubError, DeserializeError
        {
            string m_name = "addr.qspn_manager.got_prepare_destroy";
            ArrayList<string> args = new ArrayList<string>();

            string resp;
            try {
                resp = rmt(m_name, args);
            }
            catch (zcd.ZCDError e) {
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


        public void got_destroy() throws StubError, DeserializeError
        {
            string m_name = "addr.qspn_manager.got_destroy";
            ArrayList<string> args = new ArrayList<string>();

            string resp;
            try {
                resp = rmt(m_name, args);
            }
            catch (zcd.ZCDError e) {
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

    internal class PeersManagerRemote : Object, IPeersManagerStub
    {
        private unowned FakeRmt rmt;
        public PeersManagerRemote(FakeRmt rmt)
        {
            this.rmt = rmt;
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
            catch (zcd.ZCDError e) {
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
            catch (zcd.ZCDError e) {
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
            catch (zcd.ZCDError e) {
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


        public void set_refuse_message(int arg0, string arg1, int arg2, IPeerTupleNode arg3) throws StubError, DeserializeError
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
                // serialize arg2 (int e_lvl)
                args.add(prepare_argument_int64(arg2));
            }
            {
                // serialize arg3 (IPeerTupleNode respondant)
                args.add(prepare_argument_object(arg3));
            }

            string resp;
            try {
                resp = rmt(m_name, args);
            }
            catch (zcd.ZCDError e) {
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
            catch (zcd.ZCDError e) {
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
            catch (zcd.ZCDError e) {
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
            catch (zcd.ZCDError e) {
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
            catch (zcd.ZCDError e) {
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


        public void set_missing_optional_maps(int arg0) throws StubError, DeserializeError
        {
            string m_name = "addr.peers_manager.set_missing_optional_maps";
            ArrayList<string> args = new ArrayList<string>();
            {
                // serialize arg0 (int msg_id)
                args.add(prepare_argument_int64(arg0));
            }

            string resp;
            try {
                resp = rmt(m_name, args);
            }
            catch (zcd.ZCDError e) {
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
            catch (zcd.ZCDError e) {
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


        public void give_participant_maps(IPeerParticipantSet arg0) throws StubError, DeserializeError
        {
            string m_name = "addr.peers_manager.give_participant_maps";
            ArrayList<string> args = new ArrayList<string>();
            {
                // serialize arg0 (IPeerParticipantSet maps)
                args.add(prepare_argument_object(arg0));
            }

            string resp;
            try {
                resp = rmt(m_name, args);
            }
            catch (zcd.ZCDError e) {
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


        public IPeerParticipantSet ask_participant_maps() throws StubError, DeserializeError
        {
            string m_name = "addr.peers_manager.ask_participant_maps";
            ArrayList<string> args = new ArrayList<string>();

            string resp;
            try {
                resp = rmt(m_name, args);
            }
            catch (zcd.ZCDError e) {
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
                if (error_domain_code == "DeserializeError.GENERIC")
                    throw new DeserializeError.GENERIC(error_message);
                throw new DeserializeError.GENERIC(@"$(doing): unrecognized error $(error_domain_code) $(error_message)");
            }
            if (ret is ISerializable)
                if (!((ISerializable)ret).check_deserialization())
                    throw new DeserializeError.GENERIC(@"$(doing): instance of $(ret.get_type().name()) has not been fully deserialized");
            return (IPeerParticipantSet)ret;
        }

    }

    internal class CoordinatorManagerRemote : Object, ICoordinatorManagerStub
    {
        private unowned FakeRmt rmt;
        public CoordinatorManagerRemote(FakeRmt rmt)
        {
            this.rmt = rmt;
        }

        public void execute_prepare_migration(ICoordTupleGNode arg0, int64 arg1, int arg2, int arg3, ICoordObject arg4) throws StubError, DeserializeError
        {
            string m_name = "addr.coordinator_manager.execute_prepare_migration";
            ArrayList<string> args = new ArrayList<string>();
            {
                // serialize arg0 (ICoordTupleGNode tuple)
                args.add(prepare_argument_object(arg0));
            }
            {
                // serialize arg1 (int64 fp_id)
                args.add(prepare_argument_int64(arg1));
            }
            {
                // serialize arg2 (int propagation_id)
                args.add(prepare_argument_int64(arg2));
            }
            {
                // serialize arg3 (int lvl)
                args.add(prepare_argument_int64(arg3));
            }
            {
                // serialize arg4 (ICoordObject prepare_migration_data)
                args.add(prepare_argument_object(arg4));
            }

            string resp;
            try {
                resp = rmt(m_name, args);
            }
            catch (zcd.ZCDError e) {
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


        public void execute_finish_migration(ICoordTupleGNode arg0, int64 arg1, int arg2, int arg3, ICoordObject arg4) throws StubError, DeserializeError
        {
            string m_name = "addr.coordinator_manager.execute_finish_migration";
            ArrayList<string> args = new ArrayList<string>();
            {
                // serialize arg0 (ICoordTupleGNode tuple)
                args.add(prepare_argument_object(arg0));
            }
            {
                // serialize arg1 (int64 fp_id)
                args.add(prepare_argument_int64(arg1));
            }
            {
                // serialize arg2 (int propagation_id)
                args.add(prepare_argument_int64(arg2));
            }
            {
                // serialize arg3 (int lvl)
                args.add(prepare_argument_int64(arg3));
            }
            {
                // serialize arg4 (ICoordObject finish_migration_data)
                args.add(prepare_argument_object(arg4));
            }

            string resp;
            try {
                resp = rmt(m_name, args);
            }
            catch (zcd.ZCDError e) {
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


        public void execute_prepare_enter(ICoordTupleGNode arg0, int64 arg1, int arg2, int arg3, ICoordObject arg4) throws StubError, DeserializeError
        {
            string m_name = "addr.coordinator_manager.execute_prepare_enter";
            ArrayList<string> args = new ArrayList<string>();
            {
                // serialize arg0 (ICoordTupleGNode tuple)
                args.add(prepare_argument_object(arg0));
            }
            {
                // serialize arg1 (int64 fp_id)
                args.add(prepare_argument_int64(arg1));
            }
            {
                // serialize arg2 (int propagation_id)
                args.add(prepare_argument_int64(arg2));
            }
            {
                // serialize arg3 (int lvl)
                args.add(prepare_argument_int64(arg3));
            }
            {
                // serialize arg4 (ICoordObject prepare_enter_data)
                args.add(prepare_argument_object(arg4));
            }

            string resp;
            try {
                resp = rmt(m_name, args);
            }
            catch (zcd.ZCDError e) {
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


        public void execute_finish_enter(ICoordTupleGNode arg0, int64 arg1, int arg2, int arg3, ICoordObject arg4) throws StubError, DeserializeError
        {
            string m_name = "addr.coordinator_manager.execute_finish_enter";
            ArrayList<string> args = new ArrayList<string>();
            {
                // serialize arg0 (ICoordTupleGNode tuple)
                args.add(prepare_argument_object(arg0));
            }
            {
                // serialize arg1 (int64 fp_id)
                args.add(prepare_argument_int64(arg1));
            }
            {
                // serialize arg2 (int propagation_id)
                args.add(prepare_argument_int64(arg2));
            }
            {
                // serialize arg3 (int lvl)
                args.add(prepare_argument_int64(arg3));
            }
            {
                // serialize arg4 (ICoordObject finish_enter_data)
                args.add(prepare_argument_object(arg4));
            }

            string resp;
            try {
                resp = rmt(m_name, args);
            }
            catch (zcd.ZCDError e) {
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


        public void execute_we_have_splitted(ICoordTupleGNode arg0, int64 arg1, int arg2, int arg3, ICoordObject arg4) throws StubError, DeserializeError
        {
            string m_name = "addr.coordinator_manager.execute_we_have_splitted";
            ArrayList<string> args = new ArrayList<string>();
            {
                // serialize arg0 (ICoordTupleGNode tuple)
                args.add(prepare_argument_object(arg0));
            }
            {
                // serialize arg1 (int64 fp_id)
                args.add(prepare_argument_int64(arg1));
            }
            {
                // serialize arg2 (int propagation_id)
                args.add(prepare_argument_int64(arg2));
            }
            {
                // serialize arg3 (int lvl)
                args.add(prepare_argument_int64(arg3));
            }
            {
                // serialize arg4 (ICoordObject we_have_splitted_data)
                args.add(prepare_argument_object(arg4));
            }

            string resp;
            try {
                resp = rmt(m_name, args);
            }
            catch (zcd.ZCDError e) {
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

    internal class HookingManagerRemote : Object, IHookingManagerStub
    {
        private unowned FakeRmt rmt;
        public HookingManagerRemote(FakeRmt rmt)
        {
            this.rmt = rmt;
        }

        public INetworkData retrieve_network_data(bool arg0) throws HookingNotPrincipalError, NotBoostrappedError, StubError, DeserializeError
        {
            string m_name = "addr.hooking_manager.retrieve_network_data";
            ArrayList<string> args = new ArrayList<string>();
            {
                // serialize arg0 (bool ask_coord)
                args.add(prepare_argument_boolean(arg0));
            }

            string resp;
            try {
                resp = rmt(m_name, args);
            }
            catch (zcd.ZCDError e) {
                throw new StubError.GENERIC(e.message);
            }

            // deserialize response
            string? error_domain = null;
            string? error_code = null;
            string? error_message = null;
            string doing = @"Reading return-value of $(m_name)";
            Object ret;
            try {
                ret = read_return_value_object_notnull(typeof(INetworkData), resp, out error_domain, out error_code, out error_message);
            } catch (HelperNotJsonError e) {
                error(@"Error parsing JSON for return-value of $(m_name): $(e.message)");
            } catch (HelperDeserializeError e) {
                throw new DeserializeError.GENERIC(@"$(doing): $(e.message)");
            }
            if (error_domain != null)
            {
                string error_domain_code = @"$(error_domain).$(error_code)";
                if (error_domain_code == "HookingNotPrincipalError.GENERIC")
                    throw new HookingNotPrincipalError.GENERIC(error_message);
                if (error_domain_code == "NotBoostrappedError.GENERIC")
                    throw new NotBoostrappedError.GENERIC(error_message);
                if (error_domain_code == "DeserializeError.GENERIC")
                    throw new DeserializeError.GENERIC(error_message);
                throw new DeserializeError.GENERIC(@"$(doing): unrecognized error $(error_domain_code) $(error_message)");
            }
            if (ret is ISerializable)
                if (!((ISerializable)ret).check_deserialization())
                    throw new DeserializeError.GENERIC(@"$(doing): instance of $(ret.get_type().name()) has not been fully deserialized");
            return (INetworkData)ret;
        }


        public IEntryData search_migration_path(int arg0) throws NoMigrationPathFoundError, MigrationPathExecuteFailureError, NotBoostrappedError, StubError, DeserializeError
        {
            string m_name = "addr.hooking_manager.search_migration_path";
            ArrayList<string> args = new ArrayList<string>();
            {
                // serialize arg0 (int lvl)
                args.add(prepare_argument_int64(arg0));
            }

            string resp;
            try {
                resp = rmt(m_name, args);
            }
            catch (zcd.ZCDError e) {
                throw new StubError.GENERIC(e.message);
            }

            // deserialize response
            string? error_domain = null;
            string? error_code = null;
            string? error_message = null;
            string doing = @"Reading return-value of $(m_name)";
            Object ret;
            try {
                ret = read_return_value_object_notnull(typeof(IEntryData), resp, out error_domain, out error_code, out error_message);
            } catch (HelperNotJsonError e) {
                error(@"Error parsing JSON for return-value of $(m_name): $(e.message)");
            } catch (HelperDeserializeError e) {
                throw new DeserializeError.GENERIC(@"$(doing): $(e.message)");
            }
            if (error_domain != null)
            {
                string error_domain_code = @"$(error_domain).$(error_code)";
                if (error_domain_code == "NoMigrationPathFoundError.GENERIC")
                    throw new NoMigrationPathFoundError.GENERIC(error_message);
                if (error_domain_code == "MigrationPathExecuteFailureError.GENERIC")
                    throw new MigrationPathExecuteFailureError.GENERIC(error_message);
                if (error_domain_code == "NotBoostrappedError.GENERIC")
                    throw new NotBoostrappedError.GENERIC(error_message);
                if (error_domain_code == "DeserializeError.GENERIC")
                    throw new DeserializeError.GENERIC(error_message);
                throw new DeserializeError.GENERIC(@"$(doing): unrecognized error $(error_domain_code) $(error_message)");
            }
            if (ret is ISerializable)
                if (!((ISerializable)ret).check_deserialization())
                    throw new DeserializeError.GENERIC(@"$(doing): instance of $(ret.get_type().name()) has not been fully deserialized");
            return (IEntryData)ret;
        }


        public void route_search_request(ISearchMigrationPathRequest arg0) throws StubError, DeserializeError
        {
            string m_name = "addr.hooking_manager.route_search_request";
            ArrayList<string> args = new ArrayList<string>();
            {
                // serialize arg0 (ISearchMigrationPathRequest p0)
                args.add(prepare_argument_object(arg0));
            }

            string resp;
            try {
                resp = rmt(m_name, args);
            }
            catch (zcd.ZCDError e) {
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


        public void route_search_error(ISearchMigrationPathErrorPkt arg0) throws StubError, DeserializeError
        {
            string m_name = "addr.hooking_manager.route_search_error";
            ArrayList<string> args = new ArrayList<string>();
            {
                // serialize arg0 (ISearchMigrationPathErrorPkt p2)
                args.add(prepare_argument_object(arg0));
            }

            string resp;
            try {
                resp = rmt(m_name, args);
            }
            catch (zcd.ZCDError e) {
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


        public void route_search_response(ISearchMigrationPathResponse arg0) throws StubError, DeserializeError
        {
            string m_name = "addr.hooking_manager.route_search_response";
            ArrayList<string> args = new ArrayList<string>();
            {
                // serialize arg0 (ISearchMigrationPathResponse p1)
                args.add(prepare_argument_object(arg0));
            }

            string resp;
            try {
                resp = rmt(m_name, args);
            }
            catch (zcd.ZCDError e) {
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


        public void route_explore_request(IExploreGNodeRequest arg0) throws StubError, DeserializeError
        {
            string m_name = "addr.hooking_manager.route_explore_request";
            ArrayList<string> args = new ArrayList<string>();
            {
                // serialize arg0 (IExploreGNodeRequest p0)
                args.add(prepare_argument_object(arg0));
            }

            string resp;
            try {
                resp = rmt(m_name, args);
            }
            catch (zcd.ZCDError e) {
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


        public void route_explore_response(IExploreGNodeResponse arg0) throws StubError, DeserializeError
        {
            string m_name = "addr.hooking_manager.route_explore_response";
            ArrayList<string> args = new ArrayList<string>();
            {
                // serialize arg0 (IExploreGNodeResponse p1)
                args.add(prepare_argument_object(arg0));
            }

            string resp;
            try {
                resp = rmt(m_name, args);
            }
            catch (zcd.ZCDError e) {
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


        public void route_delete_reserve_request(IDeleteReservationRequest arg0) throws StubError, DeserializeError
        {
            string m_name = "addr.hooking_manager.route_delete_reserve_request";
            ArrayList<string> args = new ArrayList<string>();
            {
                // serialize arg0 (IDeleteReservationRequest p0)
                args.add(prepare_argument_object(arg0));
            }

            string resp;
            try {
                resp = rmt(m_name, args);
            }
            catch (zcd.ZCDError e) {
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


        public void route_mig_request(IRequestPacket arg0) throws StubError, DeserializeError
        {
            string m_name = "addr.hooking_manager.route_mig_request";
            ArrayList<string> args = new ArrayList<string>();
            {
                // serialize arg0 (IRequestPacket p0)
                args.add(prepare_argument_object(arg0));
            }

            string resp;
            try {
                resp = rmt(m_name, args);
            }
            catch (zcd.ZCDError e) {
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


        public void route_mig_response(IResponsePacket arg0) throws StubError, DeserializeError
        {
            string m_name = "addr.hooking_manager.route_mig_response";
            ArrayList<string> args = new ArrayList<string>();
            {
                // serialize arg0 (IResponsePacket p1)
                args.add(prepare_argument_object(arg0));
            }

            string resp;
            try {
                resp = rmt(m_name, args);
            }
            catch (zcd.ZCDError e) {
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
}
