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
  void expect_ping(int guid) throws NeighborhoodUnmanagedDeviceError
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
    }

    public class UnicastID : Object
    {
        public string mac {get; private set;}
        public INeighborhoodNodeID nodeid {get; private set;}

        public UnicastID(string mac, INeighborhoodNodeID nodeid)
        {
            this.mac = mac;
            this.nodeid = nodeid;
        }
    }

    public class BroadcastID : Object
    {
        // Has the message to be ignored by a certain node?
        public INeighborhoodNodeID? ignore_nodeid {get; private set;}

        public BroadcastID(INeighborhoodNodeID? ignore_nodeid=null)
        {
            this.ignore_nodeid = ignore_nodeid;
        }
    }

}
