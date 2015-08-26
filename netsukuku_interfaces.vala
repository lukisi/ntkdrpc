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
  void nop()
 QspnManager qspn_manager
  IQspnEtpMessage get_full_etp(IQspnAddress requesting_address) throws QspnNotAcceptedError, QspnBootstrapInProgressError
  void send_etp(IQspnEtpMessage etp, bool is_full) throws QspnNotAcceptedError
 PeersManager peers_manager
  IPeerParticipantSet get_participant_set(int lvl) throws PeersInvalidRequest
  void forward_peer_message(IPeerMessage peer_message)
  IPeersRequest get_request(int msg_id, IPeerTupleNode respondant) throws PeersUnknownMessageError, PeersInvalidRequest
  void set_response(int msg_id, IPeersResponse response)
  void set_next_destination(int msg_id, IPeerTupleGNode tuple)
  void set_failure(int msg_id, IPeerTupleGNode tuple)
  void set_non_participant(int msg_id, IPeerTupleGNode tuple)
  void set_participant(int p_id, IPeerTupleGNode tuple)
 CoordinatorManager coordinator_manager
  ICoordinatorNeighborMapMessage retrieve_neighbor_map()
  ICoordinatorReservationMessage ask_reservation(int lvl) throws SaturatedGnodeError
Errors
 NeighborhoodRequestArcError(NOT_SAME_NETWORK,TOO_MANY_ARCS,TWO_ARCS_ON_COLLISION_DOMAIN,GENERIC)
 NeighborhoodUnmanagedDeviceError(GENERIC)
 QspnNotAcceptedError(GENERIC)
 QspnBootstrapInProgressError(GENERIC)
 PeersUnknownMessageError(GENERIC)
 PeersInvalidRequest(GENERIC)
 SaturatedGnodeError(GENERIC)

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

    public errordomain QspnNotAcceptedError {
        GENERIC,
    }

    public errordomain QspnBootstrapInProgressError {
        GENERIC,
    }

    public errordomain PeersUnknownMessageError {
        GENERIC,
    }

    public errordomain PeersInvalidRequest {
        GENERIC,
    }

    public errordomain SaturatedGnodeError {
        GENERIC,
    }

    public interface INeighborhoodNodeID : Object
    {
        public abstract bool i_neighborhood_equals(INeighborhoodNodeID other);
    }

    public interface IQspnEtpMessage : Object
    {
    }

    public interface IQspnAddress : Object
    {
    }

    public interface IPeerParticipantSet : Object
    {
    }

    public interface IPeerMessage : Object
    {
    }

    public interface IPeersRequest : Object
    {
    }

    public interface IPeerTupleNode : Object
    {
    }

    public interface IPeersResponse : Object
    {
    }

    public interface IPeerTupleGNode : Object
    {
    }

    public interface ICoordinatorNeighborMapMessage : Object
    {
    }

    public interface ICoordinatorReservationMessage : Object
    {
    }

    /*  Moved to file addendum.vala
    public class UnicastID : Object
    {
    }
    */

    /*  Moved to file addendum.vala
    public class BroadcastID : Object
    {
    }
    */

}
