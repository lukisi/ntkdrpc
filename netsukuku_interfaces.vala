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

/*
interfaces.rpcidl
==========================================
AddressManager addr
 NeighborhoodManager neighborhood_manager
  void here_i_am(INeighborhoodNodeID my_id, string mac, string nic_addr)
  void request_arc(INeighborhoodNodeID my_id, string mac, string nic_addr) throws NeighborhoodRequestArcError
  uint16 expect_ping(string guid, uint16 peer_port) throws NeighborhoodUnmanagedDeviceError
  void remove_arc(INeighborhoodNodeID my_id, string mac, string nic_addr)
Errors
 NeighborhoodRequestArcError(NOT_SAME_NETWORK,TOO_MANY_ARCS,TWO_ARCS_ON_COLLISION_DOMAIN,GENERIC)
 NeighborhoodUnmanagedDeviceError(GENERIC)

==========================================
 */

using Gee;
using zcd;
using zcd.ModRpc;

namespace Netsukuku
{
    public errordomain NeighborhoodRequestArcError {
        NOT_SAME_NETWORK,
        TOO_MANY_ARCS,
        TWO_ARCS_ON_COLLISION_DOMAIN,
        GENERIC,
    }

    public errordomain NeighborhoodUnmanagedDeviceError {
        GENERIC,
    }

    public interface INeighborhoodNodeID : Object
    {
        public abstract bool i_neighborhood_equals(INeighborhoodNodeID other);
        public abstract bool i_neighborhood_is_on_same_network(INeighborhoodNodeID other);
    }

    public class UnicastID : Object, Json.Serializable, ISerializable
    {
        public string mac {get; set;}
        public INeighborhoodNodeID nodeid {get; set;}

        public UnicastID(string mac, INeighborhoodNodeID nodeid)
        {
            this.mac = mac;
            this.nodeid = nodeid;
        }

        public bool deserialize_property
        (string property_name,
         out GLib.Value @value,
         GLib.ParamSpec pspec,
         Json.Node property_node)
        {
            @value = 0;
            switch (property_name) {
            case "mac":
                @value = property_node.get_string();
                break;
            case "nodeid":
                Json.Reader r = new Json.Reader(property_node.copy());
                if (r.get_null_value())
                    return false;
                if (!r.is_object())
                    return false;
                string typename;
                if (!r.read_member("typename"))
                    return false;
                if (!r.is_value())
                    return false;
                if (r.get_value().get_value_type() != typeof(string))
                    return false;
                typename = r.get_string_value();
                r.end_member();
                Type type = Type.from_name(typename);
                if (type == 0)
                    return false;
                if (!type.is_a(typeof(INeighborhoodNodeID)))
                    return false;
                if (!r.read_member("value"))
                    return false;
                r.end_member();
                unowned Json.Node p_value = property_node.get_object().get_member("value");
                Json.Node cp_value = p_value.copy();
                @value = (INeighborhoodNodeID)Json.gobject_deserialize(type, cp_value);
                break;
            default:
                return false;
            }
            return true;
        }

        public unowned GLib.ParamSpec find_property
        (string name)
        {
            return ((ObjectClass)typeof(UnicastID).class_ref()).find_property(name);
        }

        public Json.Node serialize_property
        (string property_name,
         GLib.Value @value,
         GLib.ParamSpec pspec)
        {
            switch (property_name) {
            case "mac":
                return default_serialize_property(property_name, @value, pspec);
            case "nodeid":
                Object obj = (Object)@value;
                Json.Builder b = new Json.Builder();
                b.begin_object();
                b.set_member_name("typename");
                b.add_string_value(obj.get_type().name());
                b.set_member_name("value");
                Json.Node* obj_n = Json.gobject_serialize(obj);
                b.add_value(obj_n);
                b.end_object();
                return b.get_root();
            default:
                error(@"wrong param $(property_name)");
            }
        }

        public bool check_deserialization()
        {
            return mac != null && nodeid != null;
        }
    }

    public class BroadcastID : Object
    {
        // Has the message to be ignored by a certain node?
        public INeighborhoodNodeID? ignore_nodeid {get; set;}

        public BroadcastID(INeighborhoodNodeID? ignore_nodeid=null)
        {
            this.ignore_nodeid = ignore_nodeid;
        }
    }

}
