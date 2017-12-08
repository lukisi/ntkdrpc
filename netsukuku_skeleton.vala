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
using TaskletSystem;

namespace Netsukuku
{
        public interface INeighborhoodManagerSkeleton : Object
        {
            public abstract void here_i_am(INeighborhoodNodeIDMessage my_id, string mac, string nic_addr, CallerInfo? caller=null);
            public abstract void request_arc(INeighborhoodNodeIDMessage my_id, string mac, string nic_addr, CallerInfo? caller=null) throws NeighborhoodRequestArcError;
            public abstract void remove_arc(INeighborhoodNodeIDMessage my_id, string mac, string nic_addr, CallerInfo? caller=null);
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
            public abstract ICoordinatorNeighborMapMessage retrieve_neighbor_map(CallerInfo? caller=null) throws CoordinatorNodeNotReadyError;
            public abstract ICoordinatorReservationMessage ask_reservation(int lvl, CallerInfo? caller=null) throws CoordinatorNodeNotReadyError, CoordinatorInvalidLevelError, CoordinatorSaturatedGnodeError;
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
        }

        public interface IRpcDelegate : Object
        {
            public abstract Gee.List<IAddressManagerSkeleton> get_addr_set(CallerInfo caller);
        }

        internal errordomain InSkeletonDeserializeError {
            GENERIC
        }

        internal class ZcdAddressManagerDispatcher : Object, IZcdDispatcher
        {
            private string m_name;
            private ArrayList<string> args;
            private CallerInfo caller_info;
            private Gee.List<IAddressManagerSkeleton> addr_set;
            public ZcdAddressManagerDispatcher(Gee.List<IAddressManagerSkeleton> addr_set, string m_name, Gee.List<string> args, CallerInfo caller_info)
            {
                this.addr_set = new ArrayList<IAddressManagerSkeleton>();
                this.addr_set.add_all(addr_set);
                this.m_name = m_name;
                this.args = new ArrayList<string>();
                this.args.add_all(args);
                this.caller_info = caller_info;
            }

            private string execute_or_throw_deserialize(IAddressManagerSkeleton addr) throws InSkeletonDeserializeError
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
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                            }
                            j++;
                        }
                        {
                            // deserialize arg1 (string mac)
                            string arg_name = "mac";
                            string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                            try {
                                arg1 = read_argument_string_notnull(args[j]);
                            } catch (HelperNotJsonError e) {
                                critical(@"Error parsing JSON for argument: $(e.message)");
                                critical(@" method-name: $(m_name)");
                                error(@" argument #$(j): $(args[j])");
                            } catch (HelperDeserializeError e) {
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                            }
                            j++;
                        }
                        {
                            // deserialize arg2 (string nic_addr)
                            string arg_name = "nic_addr";
                            string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                            try {
                                arg2 = read_argument_string_notnull(args[j]);
                            } catch (HelperNotJsonError e) {
                                critical(@"Error parsing JSON for argument: $(e.message)");
                                critical(@" method-name: $(m_name)");
                                error(@" argument #$(j): $(args[j])");
                            } catch (HelperDeserializeError e) {
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                            }
                            j++;
                        }

                        addr.neighborhood_manager.here_i_am(arg0, arg1, arg2, caller_info);
                        ret = prepare_return_value_null();
                    }
                    else if (m_name == "addr.neighborhood_manager.request_arc")
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
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                            }
                            j++;
                        }
                        {
                            // deserialize arg1 (string mac)
                            string arg_name = "mac";
                            string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                            try {
                                arg1 = read_argument_string_notnull(args[j]);
                            } catch (HelperNotJsonError e) {
                                critical(@"Error parsing JSON for argument: $(e.message)");
                                critical(@" method-name: $(m_name)");
                                error(@" argument #$(j): $(args[j])");
                            } catch (HelperDeserializeError e) {
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                            }
                            j++;
                        }
                        {
                            // deserialize arg2 (string nic_addr)
                            string arg_name = "nic_addr";
                            string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                            try {
                                arg2 = read_argument_string_notnull(args[j]);
                            } catch (HelperNotJsonError e) {
                                critical(@"Error parsing JSON for argument: $(e.message)");
                                critical(@" method-name: $(m_name)");
                                error(@" argument #$(j): $(args[j])");
                            } catch (HelperDeserializeError e) {
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                            }
                            j++;
                        }

                        try {
                            addr.neighborhood_manager.request_arc(arg0, arg1, arg2, caller_info);
                            ret = prepare_return_value_null();
                        } catch (NeighborhoodRequestArcError e) {
                            string code = "";
                            if (e is NeighborhoodRequestArcError.TOO_MANY_ARCS) code = "TOO_MANY_ARCS";
                            if (e is NeighborhoodRequestArcError.TWO_ARCS_ON_COLLISION_DOMAIN) code = "TWO_ARCS_ON_COLLISION_DOMAIN";
                            if (e is NeighborhoodRequestArcError.GENERIC) code = "GENERIC";
                            assert(code != "");
                            ret = prepare_error("NeighborhoodRequestArcError", code, e.message);
                        }
                    }
                    else if (m_name == "addr.neighborhood_manager.remove_arc")
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
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                            }
                            j++;
                        }
                        {
                            // deserialize arg1 (string mac)
                            string arg_name = "mac";
                            string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                            try {
                                arg1 = read_argument_string_notnull(args[j]);
                            } catch (HelperNotJsonError e) {
                                critical(@"Error parsing JSON for argument: $(e.message)");
                                critical(@" method-name: $(m_name)");
                                error(@" argument #$(j): $(args[j])");
                            } catch (HelperDeserializeError e) {
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                            }
                            j++;
                        }
                        {
                            // deserialize arg2 (string nic_addr)
                            string arg_name = "nic_addr";
                            string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                            try {
                                arg2 = read_argument_string_notnull(args[j]);
                            } catch (HelperNotJsonError e) {
                                critical(@"Error parsing JSON for argument: $(e.message)");
                                critical(@" method-name: $(m_name)");
                                error(@" argument #$(j): $(args[j])");
                            } catch (HelperDeserializeError e) {
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                            }
                            j++;
                        }

                        addr.neighborhood_manager.remove_arc(arg0, arg1, arg2, caller_info);
                        ret = prepare_return_value_null();
                    }
                    else if (m_name == "addr.neighborhood_manager.nop")
                    {
                        if (args.size != 0) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");


                        addr.neighborhood_manager.nop(caller_info);
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
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                            }
                            j++;
                        }

                        IDuplicationData? result = addr.identity_manager.match_duplication(arg0, arg1, arg2, arg3, arg4, arg5, caller_info);
                        if (result == null) ret = prepare_return_value_null();
                        else ret = prepare_return_value_object(result);
                    }
                    else if (m_name == "addr.identity_manager.get_peer_main_id")
                    {
                        if (args.size != 0) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");


                        IIdentityID result = addr.identity_manager.get_peer_main_id(caller_info);
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
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                            }
                            j++;
                        }

                        addr.identity_manager.notify_identity_arc_removed(arg0, arg1, caller_info);
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
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                            }
                            j++;
                        }

                        try {
                            IQspnEtpMessage result = addr.qspn_manager.get_full_etp(arg0, caller_info);
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
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                            }
                            j++;
                        }

                        try {
                            addr.qspn_manager.send_etp(arg0, arg1, caller_info);
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


                        addr.qspn_manager.got_prepare_destroy(caller_info);
                        ret = prepare_return_value_null();
                    }
                    else if (m_name == "addr.qspn_manager.got_destroy")
                    {
                        if (args.size != 0) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");


                        addr.qspn_manager.got_destroy(caller_info);
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
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                            }
                            j++;
                        }

                        addr.peers_manager.forward_peer_message(arg0, caller_info);
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
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                            }
                            j++;
                        }

                        try {
                            IPeersRequest result = addr.peers_manager.get_request(arg0, arg1, caller_info);
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
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                            }
                            j++;
                        }

                        addr.peers_manager.set_response(arg0, arg1, arg2, caller_info);
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
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                            }
                            j++;
                        }

                        addr.peers_manager.set_refuse_message(arg0, arg1, arg2, arg3, caller_info);
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
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                            }
                            j++;
                        }

                        addr.peers_manager.set_redo_from_start(arg0, arg1, caller_info);
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
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                            }
                            j++;
                        }

                        addr.peers_manager.set_next_destination(arg0, arg1, caller_info);
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
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                            }
                            j++;
                        }

                        addr.peers_manager.set_failure(arg0, arg1, caller_info);
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
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                            }
                            j++;
                        }

                        addr.peers_manager.set_non_participant(arg0, arg1, caller_info);
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
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                            }
                            j++;
                        }

                        addr.peers_manager.set_missing_optional_maps(arg0, caller_info);
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
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                            }
                            j++;
                        }

                        addr.peers_manager.set_participant(arg0, arg1, caller_info);
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
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                            }
                            j++;
                        }

                        addr.peers_manager.give_participant_maps(arg0, caller_info);
                        ret = prepare_return_value_null();
                    }
                    else if (m_name == "addr.peers_manager.ask_participant_maps")
                    {
                        if (args.size != 0) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");


                        IPeerParticipantSet result = addr.peers_manager.ask_participant_maps(caller_info);
                        ret = prepare_return_value_object(result);
                    }
                    else
                    {
                        throw new InSkeletonDeserializeError.GENERIC(@"Unknown method in addr.peers_manager: \"$(m_name)\"");
                    }
                }
                else if (m_name.has_prefix("addr.coordinator_manager."))
                {
                    if (m_name == "addr.coordinator_manager.retrieve_neighbor_map")
                    {
                        if (args.size != 0) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");


                        try {
                            ICoordinatorNeighborMapMessage result = addr.coordinator_manager.retrieve_neighbor_map(caller_info);
                            ret = prepare_return_value_object(result);
                        } catch (CoordinatorNodeNotReadyError e) {
                            string code = "";
                            if (e is CoordinatorNodeNotReadyError.GENERIC) code = "GENERIC";
                            assert(code != "");
                            ret = prepare_error("CoordinatorNodeNotReadyError", code, e.message);
                        }
                    }
                    else if (m_name == "addr.coordinator_manager.ask_reservation")
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
                                throw new InSkeletonDeserializeError.GENERIC(@"$(doing): $(e.message)");
                            }
                            j++;
                        }

                        try {
                            ICoordinatorReservationMessage result = addr.coordinator_manager.ask_reservation(arg0, caller_info);
                            ret = prepare_return_value_object(result);
                        } catch (CoordinatorNodeNotReadyError e) {
                            string code = "";
                            if (e is CoordinatorNodeNotReadyError.GENERIC) code = "GENERIC";
                            assert(code != "");
                            ret = prepare_error("CoordinatorNodeNotReadyError", code, e.message);
                        } catch (CoordinatorInvalidLevelError e) {
                            string code = "";
                            if (e is CoordinatorInvalidLevelError.GENERIC) code = "GENERIC";
                            assert(code != "");
                            ret = prepare_error("CoordinatorInvalidLevelError", code, e.message);
                        } catch (CoordinatorSaturatedGnodeError e) {
                            string code = "";
                            if (e is CoordinatorSaturatedGnodeError.GENERIC) code = "GENERIC";
                            assert(code != "");
                            ret = prepare_error("CoordinatorSaturatedGnodeError", code, e.message);
                        }
                    }
                    else
                    {
                        throw new InSkeletonDeserializeError.GENERIC(@"Unknown method in addr.coordinator_manager: \"$(m_name)\"");
                    }
                }
                else
                {
                    throw new InSkeletonDeserializeError.GENERIC(@"Unknown module in addr: \"$(m_name)\"");
                }
                return ret;
            }

            public string execute()
            {
                assert(! addr_set.is_empty);
                string ret = "";
                if (addr_set.size == 1)
                {
                    try {
                        ret = execute_or_throw_deserialize(addr_set[0]);
                    } catch(InSkeletonDeserializeError e) {
                        ret = prepare_error("DeserializeError", "GENERIC", e.message);
                    }
                }
                else
                {
                    foreach (var addr in addr_set)
                    {
                        try {
                            execute_or_throw_deserialize(addr);
                        } catch(InSkeletonDeserializeError e) {
                        }
                    }
                }
                return ret;
            }
        }

        public class TcpclientCallerInfo : CallerInfo
        {
            internal TcpclientCallerInfo(string my_address, string peer_address, ISourceID sourceid, IUnicastID unicastid)
            {
                this.my_address = my_address;
                this.peer_address = peer_address;
                this.sourceid = sourceid;
                this.unicastid = unicastid;
            }
            public string my_address {get; private set;}
            public string peer_address {get; private set;}
            public ISourceID sourceid {get; private set;}
            public IUnicastID unicastid {get; private set;}
        }

        internal class ZcdTcpDelegate : Object, IZcdTcpDelegate
        {
            private IRpcDelegate dlg;
            public ZcdTcpDelegate(IRpcDelegate dlg)
            {
                this.dlg = dlg;
            }

            public IZcdTcpRequestHandler get_new_handler()
            {
                return new ZcdTcpRequestHandler(dlg);
            }

        }

        internal class ZcdTcpRequestHandler : Object, IZcdTcpRequestHandler
        {
            private IRpcDelegate dlg;
            private string m_name;
            private ArrayList<string> args;
            private string unicast_id;
            private TcpclientCallerInfo? caller_info;
            public ZcdTcpRequestHandler(IRpcDelegate dlg)
            {
                this.dlg = dlg;
                args = new ArrayList<string>();
                m_name = "";
                caller_info = null;
            }

            public void set_method_name(string m_name)
            {
                this.m_name = m_name;
            }

            public void add_argument(string arg)
            {
                args.add(arg);
            }

            public void set_unicast_id (string unicast_id)
            {
                this.unicast_id = unicast_id;
            }

            public void set_caller_info(TcpCallerInfo caller_info)
            {
                ISourceID sourceid;
                IUnicastID unicastid;
               {
                // deserialize IUnicastID unicastid
                Object val;
                try {
                    val = read_direct_object_notnull(typeof(IUnicastID), unicast_id);
                } catch (HelperNotJsonError e) {
                    critical(@"Error parsing JSON for unicast_id: $(e.message)");
                    error(   @" unicast_id: $(unicast_id)");
                } catch (HelperDeserializeError e) {
                    // couldn't verify if it's for me
                    warning(@"get_dispatcher_unicast: couldn't verify if it's for me: $(e.message)");
                    return;
                }
                if (val is ISerializable)
                {
                    if (!((ISerializable)val).check_deserialization())
                    {
                        // couldn't verify if it's for me
                        warning(@"get_dispatcher_unicast: couldn't verify if it's for me: bad deserialization");
                        return;
                    }
                }
                unicastid = (IUnicastID)val;
               }
               {
                // deserialize ISourceID sourceid
                Object val;
                try {
                    val = read_direct_object_notnull(typeof(ISourceID), caller_info.source_id);
                } catch (HelperNotJsonError e) {
                    critical(@"Error parsing JSON for source_id: $(e.message)");
                    error(   @" unicast_id: $(caller_info.source_id)");
                } catch (HelperDeserializeError e) {
                    // couldn't verify whom it's from
                    warning(@"get_dispatcher_unicast: couldn't verify whom it's from: $(e.message)");
                    return;
                }
                if (val is ISerializable)
                {
                    if (!((ISerializable)val).check_deserialization())
                    {
                        // couldn't verify if it's for me
                        warning(@"get_dispatcher_unicast: couldn't verify whom it's from: bad deserialization");
                        return;
                    }
                }
                sourceid = (ISourceID)val;
               }
                this.caller_info = new TcpclientCallerInfo(caller_info.my_address, caller_info.peer_address, sourceid, unicastid);
            }

            public IZcdDispatcher? get_dispatcher()
            {
                IZcdDispatcher? ret = null;
              if (caller_info != null)
              {
                if (m_name.has_prefix("addr."))
                {
                    Gee.List<IAddressManagerSkeleton> addr_set = dlg.get_addr_set(caller_info);
                    if (addr_set.is_empty) ret = null;
                    else ret = new ZcdAddressManagerDispatcher(addr_set, m_name, args, caller_info);
                }
                else
                {
                    ret = new ZcdDispatcherForError("DeserializeError", "GENERIC", @"Unknown root in method name: \"$(m_name)\"");
                }
              }
                args = new ArrayList<string>();
                m_name = "";
                caller_info = null;
                return ret;
            }

        }

        public class UnicastCallerInfo : CallerInfo
        {
            internal UnicastCallerInfo(string dev, string peer_address, ISourceID sourceid, IUnicastID unicastid)
            {
                this.dev = dev;
                this.peer_address = peer_address;
                this.sourceid = sourceid;
                this.unicastid = unicastid;
            }
            public string dev {get; private set;}
            public string peer_address {get; private set;}
            public ISourceID sourceid {get; private set;}
            public IUnicastID unicastid {get; private set;}
        }

        public class BroadcastCallerInfo : CallerInfo
        {
            internal BroadcastCallerInfo(string dev, string peer_address, ISourceID sourceid, IBroadcastID broadcastid)
            {
                this.dev = dev;
                this.peer_address = peer_address;
                this.sourceid = sourceid;
                this.broadcastid = broadcastid;
            }
            public string dev {get; private set;}
            public string peer_address {get; private set;}
            public ISourceID sourceid {get; private set;}
            public IBroadcastID broadcastid {get; private set;}
        }

        internal class ZcdUdpRequestMessageDelegate : Object, IZcdUdpRequestMessageDelegate
        {
            private IRpcDelegate dlg;
            public ZcdUdpRequestMessageDelegate(IRpcDelegate dlg)
            {
                this.dlg = dlg;
            }

            public IZcdDispatcher? get_dispatcher_unicast(
                int id, string unicast_id,
                string m_name, Gee.List<string> arguments,
                UdpCallerInfo caller_info)
            {
                ISourceID sourceid;
                IUnicastID unicastid;
               {
                // deserialize IUnicastID unicastid
                Object val;
                try {
                    val = read_direct_object_notnull(typeof(IUnicastID), unicast_id);
                } catch (HelperNotJsonError e) {
                    critical(@"Error parsing JSON for unicast_id: $(e.message)");
                    error(   @" unicast_id: $(unicast_id)");
                } catch (HelperDeserializeError e) {
                    // couldn't verify if it's for me
                    warning(@"get_dispatcher_unicast: couldn't verify if it's for me: $(e.message)");
                    return null;
                }
                if (val is ISerializable)
                {
                    if (!((ISerializable)val).check_deserialization())
                    {
                        // couldn't verify if it's for me
                        warning(@"get_dispatcher_unicast: couldn't verify if it's for me: bad deserialization");
                        return null;
                    }
                }
                unicastid = (IUnicastID)val;
               }
               {
                // deserialize ISourceID sourceid
                Object val;
                try {
                    val = read_direct_object_notnull(typeof(ISourceID), caller_info.source_id);
                } catch (HelperNotJsonError e) {
                    critical(@"Error parsing JSON for source_id: $(e.message)");
                    error(   @" unicast_id: $(caller_info.source_id)");
                } catch (HelperDeserializeError e) {
                    // couldn't verify whom it's from
                    warning(@"get_dispatcher_unicast: couldn't verify whom it's from: $(e.message)");
                    return null;
                }
                if (val is ISerializable)
                {
                    if (!((ISerializable)val).check_deserialization())
                    {
                        // couldn't verify if it's for me
                        warning(@"get_dispatcher_unicast: couldn't verify whom it's from: bad deserialization");
                        return null;
                    }
                }
                sourceid = (ISourceID)val;
               }
                // call delegate
                UnicastCallerInfo my_caller_info = new UnicastCallerInfo(caller_info.dev, caller_info.peer_address, sourceid, unicastid);
                IZcdDispatcher ret;
                if (m_name.has_prefix("addr."))
                {
                    Gee.List<IAddressManagerSkeleton> addr_set = dlg.get_addr_set(my_caller_info);
                    if (addr_set.is_empty) ret = null;
                    else ret = new ZcdAddressManagerDispatcher(addr_set, m_name, arguments, my_caller_info);
                }
                else
                {
                    ret = new ZcdDispatcherForError("DeserializeError", "GENERIC", @"Unknown root in method name: \"$(m_name)\"");
                }
                return ret;
            }

            public IZcdDispatcher? get_dispatcher_broadcast(
                int id, string broadcast_id,
                string m_name, Gee.List<string> arguments,
                UdpCallerInfo caller_info)
            {
                ISourceID sourceid;
                IBroadcastID broadcastid;
               {
                // deserialize IBroadcastID broadcastid
                Object val;
                try {
                    val = read_direct_object_notnull(typeof(IBroadcastID), broadcast_id);
                } catch (HelperNotJsonError e) {
                    critical(@"Error parsing JSON for broadcast_id: $(e.message)");
                    error(   @" broadcast_id: $(broadcast_id)");
                } catch (HelperDeserializeError e) {
                    // couldn't verify if it's for me
                    warning(@"get_dispatcher_broadcast: couldn't verify if it's for me: $(e.message)");
                    return null;
                }
                if (val is ISerializable)
                {
                    if (!((ISerializable)val).check_deserialization())
                    {
                        // couldn't verify if it's for me
                        warning(@"get_dispatcher_broadcast: couldn't verify if it's for me: bad deserialization");
                        return null;
                    }
                }
                broadcastid = (IBroadcastID)val;
               }
               {
                // deserialize ISourceID sourceid
                Object val;
                try {
                    val = read_direct_object_notnull(typeof(ISourceID), caller_info.source_id);
                } catch (HelperNotJsonError e) {
                    critical(@"Error parsing JSON for source_id: $(e.message)");
                    error(   @" unicast_id: $(caller_info.source_id)");
                } catch (HelperDeserializeError e) {
                    // couldn't verify whom it's from
                    warning(@"get_dispatcher_unicast: couldn't verify whom it's from: $(e.message)");
                    return null;
                }
                if (val is ISerializable)
                {
                    if (!((ISerializable)val).check_deserialization())
                    {
                        // couldn't verify if it's for me
                        warning(@"get_dispatcher_unicast: couldn't verify whom it's from: bad deserialization");
                        return null;
                    }
                }
                sourceid = (ISourceID)val;
               }
                // call delegate
                BroadcastCallerInfo my_caller_info = new BroadcastCallerInfo(caller_info.dev, caller_info.peer_address, sourceid, broadcastid);
                IZcdDispatcher ret;
                if (m_name.has_prefix("addr."))
                {
                    Gee.List<IAddressManagerSkeleton> addr_set = dlg.get_addr_set(my_caller_info);
                    if (addr_set.is_empty) ret = null;
                    else ret = new ZcdAddressManagerDispatcher(addr_set, m_name, arguments, my_caller_info);
                }
                else
                {
                    ret = new ZcdDispatcherForError("DeserializeError", "GENERIC", @"Unknown root in method name: \"$(m_name)\"");
                }
                return ret;
            }
        }

        public ITaskletHandle tcp_listen(IRpcDelegate dlg, IRpcErrorHandler err, uint16 port, string? my_addr=null)
        {
            return zcd.tcp_listen(new ZcdTcpDelegate(dlg), new ZcdTcpAcceptErrorHandler(err), port, my_addr);
        }

        public ITaskletHandle udp_listen(IRpcDelegate dlg, IRpcErrorHandler err, uint16 port, string dev)
        {
            if (map_udp_listening == null) map_udp_listening = new HashMap<string, ZcdUdpServiceMessageDelegate>();
            string k_map = @"$(dev):$(port)";
            ZcdUdpRequestMessageDelegate del_req = new ZcdUdpRequestMessageDelegate(dlg);
            ZcdUdpServiceMessageDelegate del_ser = new ZcdUdpServiceMessageDelegate();
            ZcdUdpCreateErrorHandler del_err = new ZcdUdpCreateErrorHandler(err, k_map);
            map_udp_listening[k_map] = del_ser;
            return zcd.udp_listen(del_req, del_ser, del_err, port, dev);
        }
}
