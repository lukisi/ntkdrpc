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
    public interface INeighborhoodManagerSkeleton : Object
    {
        public abstract void here_i_am(INeighborhoodNodeIDMessage my_id, string my_mac, string my_nic_addr, CallerInfo? caller=null);
        public abstract void request_arc(INeighborhoodNodeIDMessage your_id, string your_mac, string your_nic_addr, INeighborhoodNodeIDMessage my_id, string my_mac, string my_nic_addr, CallerInfo? caller=null);
        public abstract bool can_you_export(bool i_can_export, CallerInfo? caller=null);
        public abstract void remove_arc(INeighborhoodNodeIDMessage your_id, string your_mac, string your_nic_addr, INeighborhoodNodeIDMessage my_id, string my_mac, string my_nic_addr, CallerInfo? caller=null);
        public abstract void nop(CallerInfo? caller=null);
    }

    public interface IIdentityManagerSkeleton : Object
    {
        public abstract IDuplicationData? match_duplication(int migration_id, IIdentityID peer_id, IIdentityID old_id, IIdentityID new_id, string old_id_new_mac, string old_id_new_linklocal, CallerInfo? caller=null);
        public abstract IIdentityID get_peer_main_id(CallerInfo? caller=null);
        public abstract void notify_identity_arc_removed(IIdentityID peer_id, IIdentityID my_id, CallerInfo? caller=null);
    }

    public interface IQspnManagerSkeleton : Object
    {
        public abstract IQspnEtpMessage get_full_etp(IQspnAddress requesting_address, CallerInfo? caller=null) throws QspnNotAcceptedError, QspnBootstrapInProgressError;
        public abstract void send_etp(IQspnEtpMessage etp, bool is_full, CallerInfo? caller=null) throws QspnNotAcceptedError;
        public abstract void got_prepare_destroy(CallerInfo? caller=null);
        public abstract void got_destroy(CallerInfo? caller=null);
    }

    public interface IPeersManagerSkeleton : Object
    {
        public abstract void forward_peer_message(IPeerMessage peer_message, CallerInfo? caller=null);
        public abstract IPeersRequest get_request(int msg_id, IPeerTupleNode respondant, CallerInfo? caller=null) throws PeersUnknownMessageError, PeersInvalidRequest;
        public abstract void set_response(int msg_id, IPeersResponse response, IPeerTupleNode respondant, CallerInfo? caller=null);
        public abstract void set_refuse_message(int msg_id, string refuse_message, int e_lvl, IPeerTupleNode respondant, CallerInfo? caller=null);
        public abstract void set_redo_from_start(int msg_id, IPeerTupleNode respondant, CallerInfo? caller=null);
        public abstract void set_next_destination(int msg_id, IPeerTupleGNode tuple, CallerInfo? caller=null);
        public abstract void set_failure(int msg_id, IPeerTupleGNode tuple, CallerInfo? caller=null);
        public abstract void set_non_participant(int msg_id, IPeerTupleGNode tuple, CallerInfo? caller=null);
        public abstract void set_missing_optional_maps(int msg_id, CallerInfo? caller=null);
        public abstract void set_participant(int p_id, IPeerTupleGNode tuple, CallerInfo? caller=null);
        public abstract void give_participant_maps(IPeerParticipantSet maps, CallerInfo? caller=null);
        public abstract IPeerParticipantSet ask_participant_maps(CallerInfo? caller=null);
    }

    public interface ICoordinatorManagerSkeleton : Object
    {
        public abstract void execute_prepare_migration(ICoordTupleGNode tuple, int64 fp_id, int propagation_id, int lvl, ICoordObject prepare_migration_data, CallerInfo? caller=null);
        public abstract void execute_finish_migration(ICoordTupleGNode tuple, int64 fp_id, int propagation_id, int lvl, ICoordObject finish_migration_data, CallerInfo? caller=null);
        public abstract void execute_prepare_enter(ICoordTupleGNode tuple, int64 fp_id, int propagation_id, int lvl, ICoordObject prepare_enter_data, CallerInfo? caller=null);
        public abstract void execute_finish_enter(ICoordTupleGNode tuple, int64 fp_id, int propagation_id, int lvl, ICoordObject finish_enter_data, CallerInfo? caller=null);
        public abstract void execute_we_have_splitted(ICoordTupleGNode tuple, int64 fp_id, int propagation_id, int lvl, ICoordObject we_have_splitted_data, CallerInfo? caller=null);
    }

    public interface IHookingManagerSkeleton : Object
    {
        public abstract INetworkData retrieve_network_data(bool ask_coord, CallerInfo? caller=null) throws HookingNotPrincipalError, NotBootstrappedError;
        public abstract IEntryData search_migration_path(int lvl, CallerInfo? caller=null) throws NoMigrationPathFoundError, MigrationPathExecuteFailureError, NotBootstrappedError;
        public abstract void route_search_request(ISearchMigrationPathRequest p0, CallerInfo? caller=null);
        public abstract void route_search_error(ISearchMigrationPathErrorPkt p2, CallerInfo? caller=null);
        public abstract void route_search_response(ISearchMigrationPathResponse p1, CallerInfo? caller=null);
        public abstract void route_explore_request(IExploreGNodeRequest p0, CallerInfo? caller=null);
        public abstract void route_explore_response(IExploreGNodeResponse p1, CallerInfo? caller=null);
        public abstract void route_delete_reserve_request(IDeleteReservationRequest p0, CallerInfo? caller=null);
        public abstract void route_mig_request(IRequestPacket p0, CallerInfo? caller=null);
        public abstract void route_mig_response(IResponsePacket p1, CallerInfo? caller=null);
    }

    public interface IAddressManagerSkeleton : Object
    {
        protected abstract unowned INeighborhoodManagerSkeleton neighborhood_manager_getter();
        public INeighborhoodManagerSkeleton neighborhood_manager {get {return neighborhood_manager_getter();}}
        protected abstract unowned IIdentityManagerSkeleton identity_manager_getter();
        public IIdentityManagerSkeleton identity_manager {get {return identity_manager_getter();}}
        protected abstract unowned IQspnManagerSkeleton qspn_manager_getter();
        public IQspnManagerSkeleton qspn_manager {get {return qspn_manager_getter();}}
        protected abstract unowned IPeersManagerSkeleton peers_manager_getter();
        public IPeersManagerSkeleton peers_manager {get {return peers_manager_getter();}}
        protected abstract unowned ICoordinatorManagerSkeleton coordinator_manager_getter();
        public ICoordinatorManagerSkeleton coordinator_manager {get {return coordinator_manager_getter();}}
        protected abstract unowned IHookingManagerSkeleton hooking_manager_getter();
        public IHookingManagerSkeleton hooking_manager {get {return hooking_manager_getter();}}
    }

    internal class AddressManagerStreamDispatcher : Object, zcd.IStreamDispatcher
    {
        public AddressManagerStreamDispatcher(IAddressManagerSkeleton addr)
        {
            this.addr = addr;
        }
        private IAddressManagerSkeleton addr;

        public string execute(string m_name, Gee.List<string> args, zcd.StreamCallerInfo caller_info)
        {
            StreamCallerInfo mod_caller_info;
            try {
                mod_caller_info = new StreamCallerInfo(caller_info);
            } catch (HelperDeserializeError e) {
                warning(@"Error deserializing parts of zcd.StreamCallerInfo: $(e.message)");
                tasklet.exit_tasklet();
            }
            try {
                return addr_dispatcher_execute_rpc(addr, m_name, args, mod_caller_info);
            } catch(InSkeletonDeserializeError e) {
                return prepare_error("DeserializeError", "GENERIC", e.message);
            }
        }
    }

    internal class AddressManagerDatagramDispatcher : Object, zcd.IDatagramDispatcher
    {
        public AddressManagerDatagramDispatcher(Gee.List<IAddressManagerSkeleton> addr_set)
        {
            this.addr_set = addr_set;
        }
        private Gee.List<IAddressManagerSkeleton> addr_set;

        public void execute(string m_name, Gee.List<string> args, zcd.DatagramCallerInfo caller_info)
        {
            assert(! addr_set.is_empty);
            foreach (var addr in addr_set)
            {
                tasklet.spawn(new DispatchTasklet(addr, m_name, args, caller_info));
            }
        }

        private class DispatchTasklet : Object, ITaskletSpawnable
        {
            public DispatchTasklet(IAddressManagerSkeleton addr, string m_name, Gee.List<string> args, zcd.DatagramCallerInfo caller_info)
            {
                this.addr = addr;
                this.m_name = m_name;
                this.args = args;
                this.caller_info = caller_info;
            }
            private IAddressManagerSkeleton addr;
            private string m_name;
            private Gee.List<string> args;
            private zcd.DatagramCallerInfo caller_info;
            public void* func()
            {
                DatagramCallerInfo mod_caller_info;
                try {
                    mod_caller_info = new DatagramCallerInfo(caller_info);
                } catch (HelperDeserializeError e) {
                    warning(@"Error deserializing parts of zcd.DatagramCallerInfo: $(e.message)");
                    tasklet.exit_tasklet();
                }
                try {
                    addr_dispatcher_execute_rpc(addr, m_name, args, mod_caller_info);
                } catch(InSkeletonDeserializeError e) {
                }
                return null;
            }
        }
    }

    internal string addr_dispatcher_execute_rpc(
        IAddressManagerSkeleton addr,
        string m_name, Gee.List<string> args, CallerInfo mod_caller_info)
        throws InSkeletonDeserializeError
    {
        string ret;
        if (m_name.has_prefix("addr.neighborhood_manager."))
        {
            if (m_name == "addr.neighborhood_manager.here_i_am")
            {
                if (args.size != 3) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                INeighborhoodNodeIDMessage arg0;
                string arg1;
                string arg2;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (INeighborhoodNodeIDMessage my_id)
                    string arg_name = "my_id";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(INeighborhoodNodeIDMessage), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg0 = (INeighborhoodNodeIDMessage)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg1 (string my_mac)
                    string arg_name = "my_mac";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        arg1 = read_argument_string_notnull(args[j]);
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg2 (string my_nic_addr)
                    string arg_name = "my_nic_addr";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        arg2 = read_argument_string_notnull(args[j]);
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                addr.neighborhood_manager.here_i_am(arg0, arg1, arg2, mod_caller_info);
                ret = prepare_return_value_null();
            }
            else if (m_name == "addr.neighborhood_manager.request_arc")
            {
                if (args.size != 6) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                INeighborhoodNodeIDMessage arg0;
                string arg1;
                string arg2;
                INeighborhoodNodeIDMessage arg3;
                string arg4;
                string arg5;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (INeighborhoodNodeIDMessage your_id)
                    string arg_name = "your_id";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(INeighborhoodNodeIDMessage), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg0 = (INeighborhoodNodeIDMessage)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg1 (string your_mac)
                    string arg_name = "your_mac";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        arg1 = read_argument_string_notnull(args[j]);
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg2 (string your_nic_addr)
                    string arg_name = "your_nic_addr";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        arg2 = read_argument_string_notnull(args[j]);
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg3 (INeighborhoodNodeIDMessage my_id)
                    string arg_name = "my_id";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(INeighborhoodNodeIDMessage), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg3 = (INeighborhoodNodeIDMessage)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg4 (string my_mac)
                    string arg_name = "my_mac";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        arg4 = read_argument_string_notnull(args[j]);
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg5 (string my_nic_addr)
                    string arg_name = "my_nic_addr";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        arg5 = read_argument_string_notnull(args[j]);
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                addr.neighborhood_manager.request_arc(arg0, arg1, arg2, arg3, arg4, arg5, mod_caller_info);
                ret = prepare_return_value_null();
            }
            else if (m_name == "addr.neighborhood_manager.can_you_export")
            {
                if (args.size != 1) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                bool arg0;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (bool i_can_export)
                    string arg_name = "i_can_export";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        arg0 = read_argument_bool_notnull(args[j]);
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                bool result = addr.neighborhood_manager.can_you_export(arg0, mod_caller_info);
                ret = prepare_return_value_boolean(result);
            }
            else if (m_name == "addr.neighborhood_manager.remove_arc")
            {
                if (args.size != 6) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                INeighborhoodNodeIDMessage arg0;
                string arg1;
                string arg2;
                INeighborhoodNodeIDMessage arg3;
                string arg4;
                string arg5;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (INeighborhoodNodeIDMessage your_id)
                    string arg_name = "your_id";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(INeighborhoodNodeIDMessage), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg0 = (INeighborhoodNodeIDMessage)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg1 (string your_mac)
                    string arg_name = "your_mac";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        arg1 = read_argument_string_notnull(args[j]);
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg2 (string your_nic_addr)
                    string arg_name = "your_nic_addr";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        arg2 = read_argument_string_notnull(args[j]);
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg3 (INeighborhoodNodeIDMessage my_id)
                    string arg_name = "my_id";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(INeighborhoodNodeIDMessage), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg3 = (INeighborhoodNodeIDMessage)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg4 (string my_mac)
                    string arg_name = "my_mac";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        arg4 = read_argument_string_notnull(args[j]);
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg5 (string my_nic_addr)
                    string arg_name = "my_nic_addr";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        arg5 = read_argument_string_notnull(args[j]);
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                addr.neighborhood_manager.remove_arc(arg0, arg1, arg2, arg3, arg4, arg5, mod_caller_info);
                ret = prepare_return_value_null();
            }
            else if (m_name == "addr.neighborhood_manager.nop")
            {
                if (args.size != 0) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");


                addr.neighborhood_manager.nop(mod_caller_info);
                ret = prepare_return_value_null();
            }
            else
            {
                throw new InSkeletonDeserializeError.GENERIC(@"Unknown method in addr.neighborhood_manager: \"$(m_name)\"");
            }
        }
        else if (m_name.has_prefix("addr.identity_manager."))
        {
            if (m_name == "addr.identity_manager.match_duplication")
            {
                if (args.size != 6) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                int arg0;
                IIdentityID arg1;
                IIdentityID arg2;
                IIdentityID arg3;
                string arg4;
                string arg5;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (int migration_id)
                    string arg_name = "migration_id";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        int64 val;
                        val = read_argument_int64_notnull(args[j]);
                        if (val > int.MAX || val < int.MIN)
                            throw new InSkeletonDeserializeError.GENERIC(@"$(doing): argument overflows size of int");
                        arg0 = (int)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg1 (IIdentityID peer_id)
                    string arg_name = "peer_id";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(IIdentityID), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg1 = (IIdentityID)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg2 (IIdentityID old_id)
                    string arg_name = "old_id";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(IIdentityID), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg2 = (IIdentityID)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg3 (IIdentityID new_id)
                    string arg_name = "new_id";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(IIdentityID), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg3 = (IIdentityID)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg4 (string old_id_new_mac)
                    string arg_name = "old_id_new_mac";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        arg4 = read_argument_string_notnull(args[j]);
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg5 (string old_id_new_linklocal)
                    string arg_name = "old_id_new_linklocal";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        arg5 = read_argument_string_notnull(args[j]);
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                IDuplicationData? result = addr.identity_manager.match_duplication(arg0, arg1, arg2, arg3, arg4, arg5, mod_caller_info);
                if (result == null) ret = prepare_return_value_null();
                else ret = prepare_return_value_object(result);
            }
            else if (m_name == "addr.identity_manager.get_peer_main_id")
            {
                if (args.size != 0) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");


                IIdentityID result = addr.identity_manager.get_peer_main_id(mod_caller_info);
                ret = prepare_return_value_object(result);
            }
            else if (m_name == "addr.identity_manager.notify_identity_arc_removed")
            {
                if (args.size != 2) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                IIdentityID arg0;
                IIdentityID arg1;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (IIdentityID peer_id)
                    string arg_name = "peer_id";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(IIdentityID), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg0 = (IIdentityID)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg1 (IIdentityID my_id)
                    string arg_name = "my_id";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(IIdentityID), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg1 = (IIdentityID)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                addr.identity_manager.notify_identity_arc_removed(arg0, arg1, mod_caller_info);
                ret = prepare_return_value_null();
            }
            else
            {
                throw new InSkeletonDeserializeError.GENERIC(@"Unknown method in addr.identity_manager: \"$(m_name)\"");
            }
        }
        else if (m_name.has_prefix("addr.qspn_manager."))
        {
            if (m_name == "addr.qspn_manager.get_full_etp")
            {
                if (args.size != 1) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                IQspnAddress arg0;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (IQspnAddress requesting_address)
                    string arg_name = "requesting_address";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(IQspnAddress), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg0 = (IQspnAddress)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                try {
                    IQspnEtpMessage result = addr.qspn_manager.get_full_etp(arg0, mod_caller_info);
                    ret = prepare_return_value_object(result);
                } catch (QspnNotAcceptedError e) {
                    string code = "";
                        if (e is QspnNotAcceptedError.GENERIC) code = "GENERIC";
                    assert(code != "");
                    ret = prepare_error("QspnNotAcceptedError", code, e.message);
                } catch (QspnBootstrapInProgressError e) {
                    string code = "";
                        if (e is QspnBootstrapInProgressError.GENERIC) code = "GENERIC";
                    assert(code != "");
                    ret = prepare_error("QspnBootstrapInProgressError", code, e.message);
                }
            }
            else if (m_name == "addr.qspn_manager.send_etp")
            {
                if (args.size != 2) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                IQspnEtpMessage arg0;
                bool arg1;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (IQspnEtpMessage etp)
                    string arg_name = "etp";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(IQspnEtpMessage), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg0 = (IQspnEtpMessage)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg1 (bool is_full)
                    string arg_name = "is_full";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        arg1 = read_argument_bool_notnull(args[j]);
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                try {
                    addr.qspn_manager.send_etp(arg0, arg1, mod_caller_info);
                    ret = prepare_return_value_null();
                } catch (QspnNotAcceptedError e) {
                    string code = "";
                        if (e is QspnNotAcceptedError.GENERIC) code = "GENERIC";
                    assert(code != "");
                    ret = prepare_error("QspnNotAcceptedError", code, e.message);
                }
            }
            else if (m_name == "addr.qspn_manager.got_prepare_destroy")
            {
                if (args.size != 0) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");


                addr.qspn_manager.got_prepare_destroy(mod_caller_info);
                ret = prepare_return_value_null();
            }
            else if (m_name == "addr.qspn_manager.got_destroy")
            {
                if (args.size != 0) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");


                addr.qspn_manager.got_destroy(mod_caller_info);
                ret = prepare_return_value_null();
            }
            else
            {
                throw new InSkeletonDeserializeError.GENERIC(@"Unknown method in addr.qspn_manager: \"$(m_name)\"");
            }
        }
        else if (m_name.has_prefix("addr.peers_manager."))
        {
            if (m_name == "addr.peers_manager.forward_peer_message")
            {
                if (args.size != 1) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                IPeerMessage arg0;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (IPeerMessage peer_message)
                    string arg_name = "peer_message";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(IPeerMessage), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg0 = (IPeerMessage)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                addr.peers_manager.forward_peer_message(arg0, mod_caller_info);
                ret = prepare_return_value_null();
            }
            else if (m_name == "addr.peers_manager.get_request")
            {
                if (args.size != 2) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                int arg0;
                IPeerTupleNode arg1;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (int msg_id)
                    string arg_name = "msg_id";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        int64 val;
                        val = read_argument_int64_notnull(args[j]);
                        if (val > int.MAX || val < int.MIN)
                            throw new InSkeletonDeserializeError.GENERIC(@"$(doing): argument overflows size of int");
                        arg0 = (int)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg1 (IPeerTupleNode respondant)
                    string arg_name = "respondant";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(IPeerTupleNode), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg1 = (IPeerTupleNode)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                try {
                    IPeersRequest result = addr.peers_manager.get_request(arg0, arg1, mod_caller_info);
                    ret = prepare_return_value_object(result);
                } catch (PeersUnknownMessageError e) {
                    string code = "";
                        if (e is PeersUnknownMessageError.GENERIC) code = "GENERIC";
                    assert(code != "");
                    ret = prepare_error("PeersUnknownMessageError", code, e.message);
                } catch (PeersInvalidRequest e) {
                    string code = "";
                        if (e is PeersInvalidRequest.GENERIC) code = "GENERIC";
                    assert(code != "");
                    ret = prepare_error("PeersInvalidRequest", code, e.message);
                }
            }
            else if (m_name == "addr.peers_manager.set_response")
            {
                if (args.size != 3) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                int arg0;
                IPeersResponse arg1;
                IPeerTupleNode arg2;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (int msg_id)
                    string arg_name = "msg_id";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        int64 val;
                        val = read_argument_int64_notnull(args[j]);
                        if (val > int.MAX || val < int.MIN)
                            throw new InSkeletonDeserializeError.GENERIC(@"$(doing): argument overflows size of int");
                        arg0 = (int)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg1 (IPeersResponse response)
                    string arg_name = "response";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(IPeersResponse), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg1 = (IPeersResponse)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg2 (IPeerTupleNode respondant)
                    string arg_name = "respondant";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(IPeerTupleNode), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg2 = (IPeerTupleNode)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                addr.peers_manager.set_response(arg0, arg1, arg2, mod_caller_info);
                ret = prepare_return_value_null();
            }
            else if (m_name == "addr.peers_manager.set_refuse_message")
            {
                if (args.size != 4) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                int arg0;
                string arg1;
                int arg2;
                IPeerTupleNode arg3;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (int msg_id)
                    string arg_name = "msg_id";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        int64 val;
                        val = read_argument_int64_notnull(args[j]);
                        if (val > int.MAX || val < int.MIN)
                            throw new InSkeletonDeserializeError.GENERIC(@"$(doing): argument overflows size of int");
                        arg0 = (int)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg1 (string refuse_message)
                    string arg_name = "refuse_message";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        arg1 = read_argument_string_notnull(args[j]);
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg2 (int e_lvl)
                    string arg_name = "e_lvl";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        int64 val;
                        val = read_argument_int64_notnull(args[j]);
                        if (val > int.MAX || val < int.MIN)
                            throw new InSkeletonDeserializeError.GENERIC(@"$(doing): argument overflows size of int");
                        arg2 = (int)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg3 (IPeerTupleNode respondant)
                    string arg_name = "respondant";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(IPeerTupleNode), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg3 = (IPeerTupleNode)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                addr.peers_manager.set_refuse_message(arg0, arg1, arg2, arg3, mod_caller_info);
                ret = prepare_return_value_null();
            }
            else if (m_name == "addr.peers_manager.set_redo_from_start")
            {
                if (args.size != 2) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                int arg0;
                IPeerTupleNode arg1;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (int msg_id)
                    string arg_name = "msg_id";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        int64 val;
                        val = read_argument_int64_notnull(args[j]);
                        if (val > int.MAX || val < int.MIN)
                            throw new InSkeletonDeserializeError.GENERIC(@"$(doing): argument overflows size of int");
                        arg0 = (int)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg1 (IPeerTupleNode respondant)
                    string arg_name = "respondant";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(IPeerTupleNode), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg1 = (IPeerTupleNode)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                addr.peers_manager.set_redo_from_start(arg0, arg1, mod_caller_info);
                ret = prepare_return_value_null();
            }
            else if (m_name == "addr.peers_manager.set_next_destination")
            {
                if (args.size != 2) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                int arg0;
                IPeerTupleGNode arg1;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (int msg_id)
                    string arg_name = "msg_id";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        int64 val;
                        val = read_argument_int64_notnull(args[j]);
                        if (val > int.MAX || val < int.MIN)
                            throw new InSkeletonDeserializeError.GENERIC(@"$(doing): argument overflows size of int");
                        arg0 = (int)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg1 (IPeerTupleGNode tuple)
                    string arg_name = "tuple";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(IPeerTupleGNode), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg1 = (IPeerTupleGNode)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                addr.peers_manager.set_next_destination(arg0, arg1, mod_caller_info);
                ret = prepare_return_value_null();
            }
            else if (m_name == "addr.peers_manager.set_failure")
            {
                if (args.size != 2) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                int arg0;
                IPeerTupleGNode arg1;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (int msg_id)
                    string arg_name = "msg_id";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        int64 val;
                        val = read_argument_int64_notnull(args[j]);
                        if (val > int.MAX || val < int.MIN)
                            throw new InSkeletonDeserializeError.GENERIC(@"$(doing): argument overflows size of int");
                        arg0 = (int)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg1 (IPeerTupleGNode tuple)
                    string arg_name = "tuple";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(IPeerTupleGNode), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg1 = (IPeerTupleGNode)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                addr.peers_manager.set_failure(arg0, arg1, mod_caller_info);
                ret = prepare_return_value_null();
            }
            else if (m_name == "addr.peers_manager.set_non_participant")
            {
                if (args.size != 2) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                int arg0;
                IPeerTupleGNode arg1;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (int msg_id)
                    string arg_name = "msg_id";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        int64 val;
                        val = read_argument_int64_notnull(args[j]);
                        if (val > int.MAX || val < int.MIN)
                            throw new InSkeletonDeserializeError.GENERIC(@"$(doing): argument overflows size of int");
                        arg0 = (int)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg1 (IPeerTupleGNode tuple)
                    string arg_name = "tuple";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(IPeerTupleGNode), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg1 = (IPeerTupleGNode)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                addr.peers_manager.set_non_participant(arg0, arg1, mod_caller_info);
                ret = prepare_return_value_null();
            }
            else if (m_name == "addr.peers_manager.set_missing_optional_maps")
            {
                if (args.size != 1) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                int arg0;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (int msg_id)
                    string arg_name = "msg_id";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        int64 val;
                        val = read_argument_int64_notnull(args[j]);
                        if (val > int.MAX || val < int.MIN)
                            throw new InSkeletonDeserializeError.GENERIC(@"$(doing): argument overflows size of int");
                        arg0 = (int)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                addr.peers_manager.set_missing_optional_maps(arg0, mod_caller_info);
                ret = prepare_return_value_null();
            }
            else if (m_name == "addr.peers_manager.set_participant")
            {
                if (args.size != 2) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                int arg0;
                IPeerTupleGNode arg1;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (int p_id)
                    string arg_name = "p_id";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        int64 val;
                        val = read_argument_int64_notnull(args[j]);
                        if (val > int.MAX || val < int.MIN)
                            throw new InSkeletonDeserializeError.GENERIC(@"$(doing): argument overflows size of int");
                        arg0 = (int)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg1 (IPeerTupleGNode tuple)
                    string arg_name = "tuple";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(IPeerTupleGNode), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg1 = (IPeerTupleGNode)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                addr.peers_manager.set_participant(arg0, arg1, mod_caller_info);
                ret = prepare_return_value_null();
            }
            else if (m_name == "addr.peers_manager.give_participant_maps")
            {
                if (args.size != 1) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                IPeerParticipantSet arg0;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (IPeerParticipantSet maps)
                    string arg_name = "maps";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(IPeerParticipantSet), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg0 = (IPeerParticipantSet)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                addr.peers_manager.give_participant_maps(arg0, mod_caller_info);
                ret = prepare_return_value_null();
            }
            else if (m_name == "addr.peers_manager.ask_participant_maps")
            {
                if (args.size != 0) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");


                IPeerParticipantSet result = addr.peers_manager.ask_participant_maps(mod_caller_info);
                ret = prepare_return_value_object(result);
            }
            else
            {
                throw new InSkeletonDeserializeError.GENERIC(@"Unknown method in addr.peers_manager: \"$(m_name)\"");
            }
        }
        else if (m_name.has_prefix("addr.coordinator_manager."))
        {
            if (m_name == "addr.coordinator_manager.execute_prepare_migration")
            {
                if (args.size != 5) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                ICoordTupleGNode arg0;
                int64 arg1;
                int arg2;
                int arg3;
                ICoordObject arg4;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (ICoordTupleGNode tuple)
                    string arg_name = "tuple";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(ICoordTupleGNode), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg0 = (ICoordTupleGNode)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg1 (int64 fp_id)
                    string arg_name = "fp_id";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        int64 val;
                        val = read_argument_int64_notnull(args[j]);
                        arg1 = (int)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg2 (int propagation_id)
                    string arg_name = "propagation_id";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        int64 val;
                        val = read_argument_int64_notnull(args[j]);
                        if (val > int.MAX || val < int.MIN)
                            throw new InSkeletonDeserializeError.GENERIC(@"$(doing): argument overflows size of int");
                        arg2 = (int)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg3 (int lvl)
                    string arg_name = "lvl";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        int64 val;
                        val = read_argument_int64_notnull(args[j]);
                        if (val > int.MAX || val < int.MIN)
                            throw new InSkeletonDeserializeError.GENERIC(@"$(doing): argument overflows size of int");
                        arg3 = (int)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg4 (ICoordObject prepare_migration_data)
                    string arg_name = "prepare_migration_data";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(ICoordObject), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg4 = (ICoordObject)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                addr.coordinator_manager.execute_prepare_migration(arg0, arg1, arg2, arg3, arg4, mod_caller_info);
                ret = prepare_return_value_null();
            }
            else if (m_name == "addr.coordinator_manager.execute_finish_migration")
            {
                if (args.size != 5) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                ICoordTupleGNode arg0;
                int64 arg1;
                int arg2;
                int arg3;
                ICoordObject arg4;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (ICoordTupleGNode tuple)
                    string arg_name = "tuple";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(ICoordTupleGNode), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg0 = (ICoordTupleGNode)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg1 (int64 fp_id)
                    string arg_name = "fp_id";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        int64 val;
                        val = read_argument_int64_notnull(args[j]);
                        arg1 = (int)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg2 (int propagation_id)
                    string arg_name = "propagation_id";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        int64 val;
                        val = read_argument_int64_notnull(args[j]);
                        if (val > int.MAX || val < int.MIN)
                            throw new InSkeletonDeserializeError.GENERIC(@"$(doing): argument overflows size of int");
                        arg2 = (int)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg3 (int lvl)
                    string arg_name = "lvl";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        int64 val;
                        val = read_argument_int64_notnull(args[j]);
                        if (val > int.MAX || val < int.MIN)
                            throw new InSkeletonDeserializeError.GENERIC(@"$(doing): argument overflows size of int");
                        arg3 = (int)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg4 (ICoordObject finish_migration_data)
                    string arg_name = "finish_migration_data";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(ICoordObject), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg4 = (ICoordObject)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                addr.coordinator_manager.execute_finish_migration(arg0, arg1, arg2, arg3, arg4, mod_caller_info);
                ret = prepare_return_value_null();
            }
            else if (m_name == "addr.coordinator_manager.execute_prepare_enter")
            {
                if (args.size != 5) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                ICoordTupleGNode arg0;
                int64 arg1;
                int arg2;
                int arg3;
                ICoordObject arg4;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (ICoordTupleGNode tuple)
                    string arg_name = "tuple";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(ICoordTupleGNode), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg0 = (ICoordTupleGNode)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg1 (int64 fp_id)
                    string arg_name = "fp_id";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        int64 val;
                        val = read_argument_int64_notnull(args[j]);
                        arg1 = (int)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg2 (int propagation_id)
                    string arg_name = "propagation_id";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        int64 val;
                        val = read_argument_int64_notnull(args[j]);
                        if (val > int.MAX || val < int.MIN)
                            throw new InSkeletonDeserializeError.GENERIC(@"$(doing): argument overflows size of int");
                        arg2 = (int)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg3 (int lvl)
                    string arg_name = "lvl";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        int64 val;
                        val = read_argument_int64_notnull(args[j]);
                        if (val > int.MAX || val < int.MIN)
                            throw new InSkeletonDeserializeError.GENERIC(@"$(doing): argument overflows size of int");
                        arg3 = (int)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg4 (ICoordObject prepare_enter_data)
                    string arg_name = "prepare_enter_data";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(ICoordObject), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg4 = (ICoordObject)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                addr.coordinator_manager.execute_prepare_enter(arg0, arg1, arg2, arg3, arg4, mod_caller_info);
                ret = prepare_return_value_null();
            }
            else if (m_name == "addr.coordinator_manager.execute_finish_enter")
            {
                if (args.size != 5) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                ICoordTupleGNode arg0;
                int64 arg1;
                int arg2;
                int arg3;
                ICoordObject arg4;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (ICoordTupleGNode tuple)
                    string arg_name = "tuple";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(ICoordTupleGNode), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg0 = (ICoordTupleGNode)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg1 (int64 fp_id)
                    string arg_name = "fp_id";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        int64 val;
                        val = read_argument_int64_notnull(args[j]);
                        arg1 = (int)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg2 (int propagation_id)
                    string arg_name = "propagation_id";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        int64 val;
                        val = read_argument_int64_notnull(args[j]);
                        if (val > int.MAX || val < int.MIN)
                            throw new InSkeletonDeserializeError.GENERIC(@"$(doing): argument overflows size of int");
                        arg2 = (int)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg3 (int lvl)
                    string arg_name = "lvl";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        int64 val;
                        val = read_argument_int64_notnull(args[j]);
                        if (val > int.MAX || val < int.MIN)
                            throw new InSkeletonDeserializeError.GENERIC(@"$(doing): argument overflows size of int");
                        arg3 = (int)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg4 (ICoordObject finish_enter_data)
                    string arg_name = "finish_enter_data";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(ICoordObject), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg4 = (ICoordObject)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                addr.coordinator_manager.execute_finish_enter(arg0, arg1, arg2, arg3, arg4, mod_caller_info);
                ret = prepare_return_value_null();
            }
            else if (m_name == "addr.coordinator_manager.execute_we_have_splitted")
            {
                if (args.size != 5) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                ICoordTupleGNode arg0;
                int64 arg1;
                int arg2;
                int arg3;
                ICoordObject arg4;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (ICoordTupleGNode tuple)
                    string arg_name = "tuple";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(ICoordTupleGNode), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg0 = (ICoordTupleGNode)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg1 (int64 fp_id)
                    string arg_name = "fp_id";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        int64 val;
                        val = read_argument_int64_notnull(args[j]);
                        arg1 = (int)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg2 (int propagation_id)
                    string arg_name = "propagation_id";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        int64 val;
                        val = read_argument_int64_notnull(args[j]);
                        if (val > int.MAX || val < int.MIN)
                            throw new InSkeletonDeserializeError.GENERIC(@"$(doing): argument overflows size of int");
                        arg2 = (int)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg3 (int lvl)
                    string arg_name = "lvl";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        int64 val;
                        val = read_argument_int64_notnull(args[j]);
                        if (val > int.MAX || val < int.MIN)
                            throw new InSkeletonDeserializeError.GENERIC(@"$(doing): argument overflows size of int");
                        arg3 = (int)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }
                {
                    // deserialize arg4 (ICoordObject we_have_splitted_data)
                    string arg_name = "we_have_splitted_data";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(ICoordObject), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg4 = (ICoordObject)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                addr.coordinator_manager.execute_we_have_splitted(arg0, arg1, arg2, arg3, arg4, mod_caller_info);
                ret = prepare_return_value_null();
            }
            else
            {
                throw new InSkeletonDeserializeError.GENERIC(@"Unknown method in addr.coordinator_manager: \"$(m_name)\"");
            }
        }
        else if (m_name.has_prefix("addr.hooking_manager."))
        {
            if (m_name == "addr.hooking_manager.retrieve_network_data")
            {
                if (args.size != 1) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                bool arg0;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (bool ask_coord)
                    string arg_name = "ask_coord";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        arg0 = read_argument_bool_notnull(args[j]);
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                try {
                    INetworkData result = addr.hooking_manager.retrieve_network_data(arg0, mod_caller_info);
                    ret = prepare_return_value_object(result);
                } catch (HookingNotPrincipalError e) {
                    string code = "";
                        if (e is HookingNotPrincipalError.GENERIC) code = "GENERIC";
                    assert(code != "");
                    ret = prepare_error("HookingNotPrincipalError", code, e.message);
                } catch (NotBootstrappedError e) {
                    string code = "";
                        if (e is NotBootstrappedError.GENERIC) code = "GENERIC";
                    assert(code != "");
                    ret = prepare_error("NotBootstrappedError", code, e.message);
                }
            }
            else if (m_name == "addr.hooking_manager.search_migration_path")
            {
                if (args.size != 1) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                int arg0;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (int lvl)
                    string arg_name = "lvl";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        int64 val;
                        val = read_argument_int64_notnull(args[j]);
                        if (val > int.MAX || val < int.MIN)
                            throw new InSkeletonDeserializeError.GENERIC(@"$(doing): argument overflows size of int");
                        arg0 = (int)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                try {
                    IEntryData result = addr.hooking_manager.search_migration_path(arg0, mod_caller_info);
                    ret = prepare_return_value_object(result);
                } catch (NoMigrationPathFoundError e) {
                    string code = "";
                        if (e is NoMigrationPathFoundError.GENERIC) code = "GENERIC";
                    assert(code != "");
                    ret = prepare_error("NoMigrationPathFoundError", code, e.message);
                } catch (MigrationPathExecuteFailureError e) {
                    string code = "";
                        if (e is MigrationPathExecuteFailureError.GENERIC) code = "GENERIC";
                    assert(code != "");
                    ret = prepare_error("MigrationPathExecuteFailureError", code, e.message);
                } catch (NotBootstrappedError e) {
                    string code = "";
                        if (e is NotBootstrappedError.GENERIC) code = "GENERIC";
                    assert(code != "");
                    ret = prepare_error("NotBootstrappedError", code, e.message);
                }
            }
            else if (m_name == "addr.hooking_manager.route_search_request")
            {
                if (args.size != 1) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                ISearchMigrationPathRequest arg0;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (ISearchMigrationPathRequest p0)
                    string arg_name = "p0";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(ISearchMigrationPathRequest), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg0 = (ISearchMigrationPathRequest)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                addr.hooking_manager.route_search_request(arg0, mod_caller_info);
                ret = prepare_return_value_null();
            }
            else if (m_name == "addr.hooking_manager.route_search_error")
            {
                if (args.size != 1) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                ISearchMigrationPathErrorPkt arg0;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (ISearchMigrationPathErrorPkt p2)
                    string arg_name = "p2";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(ISearchMigrationPathErrorPkt), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg0 = (ISearchMigrationPathErrorPkt)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                addr.hooking_manager.route_search_error(arg0, mod_caller_info);
                ret = prepare_return_value_null();
            }
            else if (m_name == "addr.hooking_manager.route_search_response")
            {
                if (args.size != 1) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                ISearchMigrationPathResponse arg0;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (ISearchMigrationPathResponse p1)
                    string arg_name = "p1";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(ISearchMigrationPathResponse), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg0 = (ISearchMigrationPathResponse)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                addr.hooking_manager.route_search_response(arg0, mod_caller_info);
                ret = prepare_return_value_null();
            }
            else if (m_name == "addr.hooking_manager.route_explore_request")
            {
                if (args.size != 1) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                IExploreGNodeRequest arg0;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (IExploreGNodeRequest p0)
                    string arg_name = "p0";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(IExploreGNodeRequest), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg0 = (IExploreGNodeRequest)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                addr.hooking_manager.route_explore_request(arg0, mod_caller_info);
                ret = prepare_return_value_null();
            }
            else if (m_name == "addr.hooking_manager.route_explore_response")
            {
                if (args.size != 1) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                IExploreGNodeResponse arg0;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (IExploreGNodeResponse p1)
                    string arg_name = "p1";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(IExploreGNodeResponse), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg0 = (IExploreGNodeResponse)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                addr.hooking_manager.route_explore_response(arg0, mod_caller_info);
                ret = prepare_return_value_null();
            }
            else if (m_name == "addr.hooking_manager.route_delete_reserve_request")
            {
                if (args.size != 1) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                IDeleteReservationRequest arg0;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (IDeleteReservationRequest p0)
                    string arg_name = "p0";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(IDeleteReservationRequest), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg0 = (IDeleteReservationRequest)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                addr.hooking_manager.route_delete_reserve_request(arg0, mod_caller_info);
                ret = prepare_return_value_null();
            }
            else if (m_name == "addr.hooking_manager.route_mig_request")
            {
                if (args.size != 1) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                IRequestPacket arg0;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (IRequestPacket p0)
                    string arg_name = "p0";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(IRequestPacket), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg0 = (IRequestPacket)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                addr.hooking_manager.route_mig_request(arg0, mod_caller_info);
                ret = prepare_return_value_null();
            }
            else if (m_name == "addr.hooking_manager.route_mig_response")
            {
                if (args.size != 1) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                // arguments:
                IResponsePacket arg0;
                // position:
                int j = 0;
                {
                    // deserialize arg0 (IResponsePacket p1)
                    string arg_name = "p1";
                    string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                    try {
                        Object val;
                        val = read_argument_object_notnull(typeof(IResponsePacket), args[j]);
                        if (val is ISerializable)
                            if (!((ISerializable)val).check_deserialization())
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                        arg0 = (IResponsePacket)val;
                    } catch (HelperNotJsonError e) {
                        critical(@"Error parsing JSON for argument: $(e.message)");
                        critical(@" method-name: $(m_name)");
                        error(@" argument #$(j): $(args[j])");
                    } catch (HelperDeserializeError e) {
                        debug(@"ZCD: IAddressManagerSkeleton: DeserializeError: $(doing): $(e.message)");
                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                    }
                    j++;
                }

                addr.hooking_manager.route_mig_response(arg0, mod_caller_info);
                ret = prepare_return_value_null();
            }
            else
            {
                throw new InSkeletonDeserializeError.GENERIC(@"Unknown method in addr.hooking_manager: \"$(m_name)\"");
            }
        }
        else
        {
            throw new InSkeletonDeserializeError.GENERIC(@"Unknown module in addr: \"$(m_name)\"");
        }
        return ret;
    }
}
