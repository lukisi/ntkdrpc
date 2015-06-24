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
        public interface INeighborhoodManagerSkeleton : Object
        {
            public abstract void here_i_am(INeighborhoodNodeID my_id, string mac, string nic_addr, CallerInfo? caller=null);
            public abstract void request_arc(INeighborhoodNodeID my_id, string mac, string nic_addr, CallerInfo? caller=null) throws NeighborhoodRequestArcError;
            public abstract uint16 expect_ping(string guid, uint16 peer_port, CallerInfo? caller=null) throws NeighborhoodUnmanagedDeviceError;
            public abstract void remove_arc(INeighborhoodNodeID my_id, string mac, string nic_addr, CallerInfo? caller=null);
        }

        public interface IAddressManagerSkeleton : Object
        {
            protected abstract unowned INeighborhoodManagerSkeleton neighborhood_manager_getter();
            public INeighborhoodManagerSkeleton neighborhood_manager {get {return neighborhood_manager_getter();}}
        }

        public interface IRpcDelegate : Object
        {
            public abstract IAddressManagerSkeleton? get_addr(CallerInfo caller);
        }

        internal errordomain InSkeletonDeserializeError {
            GENERIC
        }

        internal class ZcdAddressManagerDispatcher : Object, IZcdDispatcher
        {
            private string m_name;
            private ArrayList<string> args;
            private CallerInfo caller_info;
            private IAddressManagerSkeleton addr;
            public ZcdAddressManagerDispatcher(IAddressManagerSkeleton addr, string m_name, Gee.List<string> args, CallerInfo caller_info)
            {
                this.addr = addr;
                this.m_name = m_name;
                this.args = new ArrayList<string>();
                this.args.add_all(args);
                this.caller_info = caller_info;
            }

            private string execute_or_throw_deserialize() throws InSkeletonDeserializeError
            {
                string ret;
                if (m_name.has_prefix("addr.neighborhood_manager."))
                {
                    if (m_name == "addr.neighborhood_manager.here_i_am")
                    {
                        if (args.size != 3) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                        // arguments:
                        INeighborhoodNodeID arg0;
                        string arg1;
                        string arg2;
                        // position:
                        int j = 0;
                        {
                            // deserialize arg0 (INeighborhoodNodeID my_id)
                            string arg_name = "my_id";
                            string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                            try {
                                Object val;
                                val = read_argument_object_notnull(typeof(INeighborhoodNodeID), args[j]);
                                if (val is ISerializable)
                                    if (!((ISerializable)val).check_deserialization())
                                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                                arg0 = (INeighborhoodNodeID)val;
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
                        INeighborhoodNodeID arg0;
                        string arg1;
                        string arg2;
                        // position:
                        int j = 0;
                        {
                            // deserialize arg0 (INeighborhoodNodeID my_id)
                            string arg_name = "my_id";
                            string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                            try {
                                Object val;
                                val = read_argument_object_notnull(typeof(INeighborhoodNodeID), args[j]);
                                if (val is ISerializable)
                                    if (!((ISerializable)val).check_deserialization())
                                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                                arg0 = (INeighborhoodNodeID)val;
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
                            if (e is NeighborhoodRequestArcError.NOT_SAME_NETWORK) code = "NOT_SAME_NETWORK";
                            if (e is NeighborhoodRequestArcError.TOO_MANY_ARCS) code = "TOO_MANY_ARCS";
                            if (e is NeighborhoodRequestArcError.TWO_ARCS_ON_COLLISION_DOMAIN) code = "TWO_ARCS_ON_COLLISION_DOMAIN";
                            if (e is NeighborhoodRequestArcError.GENERIC) code = "GENERIC";
                            assert(code != "");
                            ret = prepare_error("NeighborhoodRequestArcError", code, e.message);
                        }
                    }
                    else if (m_name == "addr.neighborhood_manager.expect_ping")
                    {
                        if (args.size != 2) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                        // arguments:
                        string arg0;
                        uint16 arg1;
                        // position:
                        int j = 0;
                        {
                            // deserialize arg0 (string guid)
                            string arg_name = "guid";
                            string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                            try {
                                arg0 = read_argument_string_notnull(args[j]);
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
                            // deserialize arg1 (uint16 peer_port)
                            string arg_name = "peer_port";
                            string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                            try {
                                int64 val;
                                val = read_argument_int64_notnull(args[j]);
                                if (val > uint16.MAX || val < uint16.MIN)
                                    throw new InSkeletonDeserializeError.GENERIC(@"$(doing): argument overflows size of uint16");
                                arg1 = (uint16)val;
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
                            uint16 result = addr.neighborhood_manager.expect_ping(arg0, arg1, caller_info);
                            ret = prepare_return_value_int64(result);
                        } catch (NeighborhoodUnmanagedDeviceError e) {
                            string code = "";
                            if (e is NeighborhoodUnmanagedDeviceError.GENERIC) code = "GENERIC";
                            assert(code != "");
                            ret = prepare_error("NeighborhoodUnmanagedDeviceError", code, e.message);
                        }
                    }
                    else if (m_name == "addr.neighborhood_manager.remove_arc")
                    {
                        if (args.size != 3) throw new InSkeletonDeserializeError.GENERIC(@"Wrong number of arguments for $(m_name)");

                        // arguments:
                        INeighborhoodNodeID arg0;
                        string arg1;
                        string arg2;
                        // position:
                        int j = 0;
                        {
                            // deserialize arg0 (INeighborhoodNodeID my_id)
                            string arg_name = "my_id";
                            string doing = @"Reading argument '$(arg_name)' for $(m_name)";
                            try {
                                Object val;
                                val = read_argument_object_notnull(typeof(INeighborhoodNodeID), args[j]);
                                if (val is ISerializable)
                                    if (!((ISerializable)val).check_deserialization())
                                        throw new InSkeletonDeserializeError.GENERIC(@"$(doing): instance of $(val.get_type().name()) has not been fully deserialized");
                                arg0 = (INeighborhoodNodeID)val;
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
                    else
                    {
                        throw new InSkeletonDeserializeError.GENERIC(@"Unknown method in addr.neighborhood_manager: \"$(m_name)\"");
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
                string ret;
                try {
                    ret = execute_or_throw_deserialize();
                } catch(InSkeletonDeserializeError e) {
                    ret = prepare_error("DeserializeError", "GENERIC", e.message);
                }
                return ret;
            }
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
            private zcd.ModRpc.TcpCallerInfo? caller_info;
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

            public void set_caller_info(zcd.TcpCallerInfo caller_info)
            {
                this.caller_info = new zcd.ModRpc.TcpCallerInfo(caller_info.my_addr, caller_info.peer_addr);
            }

            public IZcdDispatcher? get_dispatcher()
            {
                IZcdDispatcher ret;
                if (m_name.has_prefix("addr."))
                {
                    IAddressManagerSkeleton? addr = dlg.get_addr(caller_info);
                    if (addr == null) ret = null;
                    else ret = new ZcdAddressManagerDispatcher(addr, m_name, args, caller_info);
                }
                else
                {
                    ret = new ZcdDispatcherForError("DeserializeError", "GENERIC", @"Unknown root in method name: \"$(m_name)\"");
                }
                args = new ArrayList<string>();
                m_name = "";
                caller_info = null;
                return ret;
            }

        }

        public class UnicastCallerInfo : CallerInfo
        {
            internal UnicastCallerInfo(string dev, string peer_address, UnicastID unicastid)
            {
                this.dev = dev;
                this.peer_address = peer_address;
                this.unicastid = unicastid;
            }
            public string dev {get; private set;}
            public string peer_address {get; private set;}
            public UnicastID unicastid {get; private set;}
        }

        public class BroadcastCallerInfo : CallerInfo
        {
            internal BroadcastCallerInfo(string dev, string peer_address, BroadcastID broadcastid)
            {
                this.dev = dev;
                this.peer_address = peer_address;
                this.broadcastid = broadcastid;
            }
            public string dev {get; private set;}
            public string peer_address {get; private set;}
            public BroadcastID broadcastid {get; private set;}
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
                zcd.UdpCallerInfo caller_info)
            {
                // deserialize UnicastID unicastid
                Object val;
                try {
                    val = read_direct_object_notnull(typeof(UnicastID), unicast_id);
                } catch (HelperNotJsonError e) {
                    critical(@"Error parsing JSON for unicast_id: $(e.message)");
                    error(   @" unicast_id: $(unicast_id)");
                } catch (HelperDeserializeError e) {
                    // couldn't verify if it's for me
                    return null;
                }
                if (val is ISerializable)
                    if (!((ISerializable)val).check_deserialization())
                    {
                        // couldn't verify if it's for me
                        return null;
                    }
                UnicastID unicastid = (UnicastID)val;
                // call delegate
                UnicastCallerInfo my_caller_info = new UnicastCallerInfo(caller_info.dev, caller_info.peer_addr, unicastid);
                IZcdDispatcher ret;
                if (m_name.has_prefix("addr."))
                {
                    IAddressManagerSkeleton? addr = dlg.get_addr(my_caller_info);
                    if (addr == null) ret = null;
                    else ret = new ZcdAddressManagerDispatcher(addr, m_name, arguments, my_caller_info);
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
                zcd.UdpCallerInfo caller_info)
            {
                // deserialize BroadcastID broadcastid
                Object val;
                try {
                    val = read_direct_object_notnull(typeof(BroadcastID), broadcast_id);
                } catch (HelperNotJsonError e) {
                    critical(@"Error parsing JSON for broadcast_id: $(e.message)");
                    error(   @" broadcast_id: $(broadcast_id)");
                } catch (HelperDeserializeError e) {
                    // couldn't verify if it's for me
                    return null;
                }
                if (val is ISerializable)
                    if (!((ISerializable)val).check_deserialization())
                        // couldn't verify if it's for me
                        return null;
                BroadcastID broadcastid = (BroadcastID)val;
                // call delegate
                BroadcastCallerInfo my_caller_info = new BroadcastCallerInfo(caller_info.dev, caller_info.peer_addr, broadcastid);
                IZcdDispatcher ret;
                if (m_name.has_prefix("addr."))
                {
                    IAddressManagerSkeleton? addr = dlg.get_addr(my_caller_info);
                    if (addr == null) ret = null;
                    else ret = new ZcdAddressManagerDispatcher(addr, m_name, arguments, my_caller_info);
                }
                else
                {
                    ret = new ZcdDispatcherForError("DeserializeError", "GENERIC", @"Unknown root in method name: \"$(m_name)\"");
                }
                return ret;
            }
        }

        public void tcp_listen(IRpcDelegate dlg, IRpcErrorHandler err, uint16 port, string? my_addr=null)
        {
            zcd.tcp_listen(new ZcdTcpDelegate(dlg), new ZcdTcpAcceptErrorHandler(err), port, my_addr);
        }

        public IZcdTaskletHandle udp_listen(IRpcDelegate dlg, IRpcErrorHandler err, uint16 port, string dev)
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
}
