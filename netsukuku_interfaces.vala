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

/*
interfaces.rpcidl
==========================================
AddressManager addr
 NeighborhoodManager neighborhood_manager
  void here_i_am(INeighborhoodNodeIDMessage my_id, string mac, string nic_addr)
  void request_arc(INeighborhoodNodeIDMessage my_id, string mac, string nic_addr) throws NeighborhoodRequestArcError
  void remove_arc(INeighborhoodNodeIDMessage my_id, string mac, string nic_addr)
  void nop()
 IdentityManager identity_manager
  IDuplicationData? match_duplication(int migration_id, IIdentityID peer_id, IIdentityID old_id, IIdentityID new_id, string old_id_new_mac, string old_id_new_linklocal)
  IIdentityID get_peer_main_id()
  void notify_identity_arc_removed(IIdentityID peer_id, IIdentityID my_id)
 QspnManager qspn_manager
  IQspnEtpMessage get_full_etp(IQspnAddress requesting_address) throws QspnNotAcceptedError, QspnBootstrapInProgressError
  void send_etp(IQspnEtpMessage etp, bool is_full) throws QspnNotAcceptedError
  void got_prepare_destroy()
  void got_destroy()
 PeersManager peers_manager
  void forward_peer_message(IPeerMessage peer_message)
  IPeersRequest get_request(int msg_id, IPeerTupleNode respondant) throws PeersUnknownMessageError, PeersInvalidRequest
  void set_response(int msg_id, IPeersResponse response, IPeerTupleNode respondant)
  void set_refuse_message(int msg_id, string refuse_message, int e_lvl, IPeerTupleNode respondant)
  void set_redo_from_start(int msg_id, IPeerTupleNode respondant)
  void set_next_destination(int msg_id, IPeerTupleGNode tuple)
  void set_failure(int msg_id, IPeerTupleGNode tuple)
  void set_non_participant(int msg_id, IPeerTupleGNode tuple)
  void set_missing_optional_maps(int msg_id)
  void set_participant(int p_id, IPeerTupleGNode tuple)
  void give_participant_maps(IPeerParticipantSet maps)
  IPeerParticipantSet ask_participant_maps()
 CoordinatorManager coordinator_manager
  void execute_prepare_migration(ICoordTupleGNode tuple, int fp_id, int propagation_id, int lvl, ICoordObject prepare_migration_data)
  void execute_finish_migration(ICoordTupleGNode tuple, int fp_id, int propagation_id, int lvl, ICoordObject finish_migration_data)
  void execute_we_have_splitted(ICoordTupleGNode tuple, int fp_id, int propagation_id, int lvl, ICoordObject we_have_splitted_data)
Errors
 NeighborhoodRequestArcError(TOO_MANY_ARCS,TWO_ARCS_ON_COLLISION_DOMAIN,GENERIC)
 QspnNotAcceptedError(GENERIC)
 QspnBootstrapInProgressError(GENERIC)
 PeersUnknownMessageError(GENERIC)
 PeersInvalidRequest(GENERIC)

==========================================
 */

using Gee;
using zcd;

namespace Netsukuku
{
    public errordomain NeighborhoodRequestArcError {
        TOO_MANY_ARCS,
        TWO_ARCS_ON_COLLISION_DOMAIN,
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

    public interface INeighborhoodNodeIDMessage : Object
    {
    }

    public interface IDuplicationData : Object
    {
    }

    public interface IIdentityID : Object
    {
    }

    public interface IQspnEtpMessage : Object
    {
    }

    public interface IQspnAddress : Object
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

    public interface IPeerParticipantSet : Object
    {
    }

    public interface ICoordTupleGNode : Object
    {
    }

    public interface ICoordObject : Object
    {
    }

    public interface ISourceID : Object
    {
    }

    public interface IUnicastID : Object
    {
    }

    public interface IBroadcastID : Object
    {
    }
}
