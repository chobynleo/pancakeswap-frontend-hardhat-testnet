// File: @openzeppelin/contracts/access/AccessControl.sol

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Contract module that allows children to implement role-based access
 * control mechanisms.
 *
 * Roles are referred to by their `bytes32` identifier. These should be exposed
 * in the external API and be unique. The best way to achieve this is by
 * using `public constant` hash digests:
 *
 * ```
 * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
 * ```
 *
 * Roles can be used to represent a set of permissions. To restrict access to a
 * function call, use {hasRole}:
 *
 * ```
 * function foo() public {
 *     require(hasRole(MY_ROLE, msg.sender));
 *     ...
 * }
 * ```
 *
 * Roles can be granted and revoked dynamically via the {grantRole} and
 * {revokeRole} functions. Each role has an associated admin role, and only
 * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
 *
 * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
 * that only accounts with this role will be able to grant or revoke other
 * roles. More complex role relationships can be created by using
 * {_setRoleAdmin}.
 *
 * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
 * grant and revoke this role. Extra precautions should be taken to secure
 * accounts that have been granted it.
 */
abstract contract AccessControl is Context {
    using EnumerableSet for EnumerableSet.AddressSet;
    using Address for address;

    struct RoleData {
        EnumerableSet.AddressSet members;
        bytes32 adminRole;
    }

    mapping(bytes32 => RoleData) private _roles;

    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;

    /**
     * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
     *
     * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
     * {RoleAdminChanged} not being emitted signaling this.
     *
     * _Available since v3.1._
     */
    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);

    /**
     * @dev Emitted when `account` is granted `role`.
     *
     * `sender` is the account that originated the contract call, an admin role
     * bearer except when using {_setupRole}.
     */
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Emitted when `account` is revoked `role`.
     *
     * `sender` is the account that originated the contract call:
     *   - if using `revokeRole`, it is the admin role bearer
     *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
     */
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Returns `true` if `account` has been granted `role`.
     */
    function hasRole(bytes32 role, address account) public view returns (bool) {
        return _roles[role].members.contains(account);
    }

    /**
     * @dev Returns the number of accounts that have `role`. Can be used
     * together with {getRoleMember} to enumerate all bearers of a role.
     */
    function getRoleMemberCount(bytes32 role) public view returns (uint256) {
        return _roles[role].members.length();
    }

    /**
     * @dev Returns one of the accounts that have `role`. `index` must be a
     * value between 0 and {getRoleMemberCount}, non-inclusive.
     *
     * Role bearers are not sorted in any particular way, and their ordering may
     * change at any point.
     *
     * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
     * you perform all queries on the same block. See the following
     * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
     * for more information.
     */
    function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
        return _roles[role].members.at(index);
    }

    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) public view returns (bytes32) {
        return _roles[role].adminRole;
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function grantRole(bytes32 role, address account) public virtual {
        require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");

        _grantRole(role, account);
    }

    /**
     * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function revokeRole(bytes32 role, address account) public virtual {
        require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");

        _revokeRole(role, account);
    }

    /**
     * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been granted `role`, emits a {RoleRevoked}
     * event.
     *
     * Requirements:
     *
     * - the caller must be `account`.
     */
    function renounceRole(bytes32 role, address account) public virtual {
        require(account == _msgSender(), "AccessControl: can only renounce roles for self");

        _revokeRole(role, account);
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event. Note that unlike {grantRole}, this function doesn't perform any
     * checks on the calling account.
     *
     * [WARNING]
     * ====
     * This function should only be called from the constructor when setting
     * up the initial roles for the system.
     *
     * Using this function in any other way is effectively circumventing the admin
     * system imposed by {AccessControl}.
     * ====
     */
    function _setupRole(bytes32 role, address account) internal virtual {
        _grantRole(role, account);
    }

    /**
     * @dev Sets `adminRole` as ``role``'s admin role.
     *
     * Emits a {RoleAdminChanged} event.
     */
    function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
        emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
        _roles[role].adminRole = adminRole;
    }

    function _grantRole(bytes32 role, address account) private {
        if (_roles[role].members.add(account)) {
            emit RoleGranted(role, account, _msgSender());
        }
    }

    function _revokeRole(bytes32 role, address account) private {
        if (_roles[role].members.remove(account)) {
            emit RoleRevoked(role, account, _msgSender());
        }
    }
}

// File: @openzeppelin/contracts/token/ERC721/ERC721Holder.sol

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Implementation of the {IERC721Receiver} interface.
 *
 * Accepts all token transfers.
 * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
 */
contract ERC721Holder is IERC721Receiver {
    /**
     * @dev See {IERC721Receiver-onERC721Received}.
     *
     * Always returns `IERC721Receiver.onERC721Received.selector`.
     */
    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }
}

// File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol

pragma solidity >=0.6.0 <0.8.0;

/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 */
interface IERC721Receiver {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

// File: contracts/PancakeProfile.sol

pragma solidity ^0.6.0;

/** @title PancakeProfile.
@dev It is a contract for users to bind their address 
to a customizable profile by depositing a NFT.
*/
contract PancakeProfile is AccessControl, ERC721Holder {
    using Counters for Counters.Counter;
    using SafeBEP20 for IBEP20;
    using SafeMath for uint256;

    IBEP20 public cakeToken;

    bytes32 public constant NFT_ROLE = keccak256("NFT_ROLE");
    bytes32 public constant POINT_ROLE = keccak256("POINT_ROLE");
    bytes32 public constant SPECIAL_ROLE = keccak256("SPECIAL_ROLE");

    uint256 public numberActiveProfiles;
    uint256 public numberCakeToReactivate;
    uint256 public numberCakeToRegister;
    uint256 public numberCakeToUpdate;
    uint256 public numberTeams;

    mapping(address => bool) public hasRegistered;

    mapping(uint256 => Team) private teams;
    mapping(address => User) private users;

    // Used for generating the teamId
    Counters.Counter private _countTeams;

    // Used for generating the userId
    Counters.Counter private _countUsers;

    // Event to notify a new team is created
    event TeamAdd(uint256 teamId, string teamName);

    // Event to notify that team points are increased
    event TeamPointIncrease(
        uint256 indexed teamId,
        uint256 numberPoints,
        uint256 indexed campaignId
    );

    event UserChangeTeam(
        address indexed userAddress,
        uint256 oldTeamId,
        uint256 newTeamId
    );

    // Event to notify that a user is registered
    event UserNew(
        address indexed userAddress,
        uint256 teamId,
        address nftAddress,
        uint256 tokenId
    );

    // Event to notify a user pausing her profile
    event UserPause(address indexed userAddress, uint256 teamId);

    // Event to notify that user points are increased
    event UserPointIncrease(
        address indexed userAddress,
        uint256 numberPoints,
        uint256 indexed campaignId
    );

    // Event to notify that a list of users have an increase in points
    event UserPointIncreaseMultiple(
        address[] userAddresses,
        uint256 numberPoints,
        uint256 indexed campaignId
    );

    // Event to notify that a user is reactivating her profile
    event UserReactivate(
        address indexed userAddress,
        uint256 teamId,
        address nftAddress,
        uint256 tokenId
    );

    // Event to notify that a user is pausing her profile
    event UserUpdate(
        address indexed userAddress,
        address nftAddress,
        uint256 tokenId
    );

    // Modifier for admin roles
    modifier onlyOwner() {
        require(
            hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
            "Not the main admin"
        );
        _;
    }

    // Modifier for point roles
    modifier onlyPoint() {
        require(hasRole(POINT_ROLE, _msgSender()), "Not a point admin");
        _;
    }

    // Modifier for special roles
    modifier onlySpecial() {
        require(hasRole(SPECIAL_ROLE, _msgSender()), "Not a special admin");
        _;
    }

    struct Team {
        string teamName;
        string teamDescription;
        uint256 numberUsers;
        uint256 numberPoints;
        bool isJoinable;
    }

    struct User {
        uint256 userId;
        uint256 numberPoints;
        uint256 teamId;
        address nftAddress;
        uint256 tokenId;
        bool isActive;
    }

    constructor(
        IBEP20 _cakeToken,
        uint256 _numberCakeToReactivate,
        uint256 _numberCakeToRegister,
        uint256 _numberCakeToUpdate
    ) public {
        cakeToken = _cakeToken;
        numberCakeToReactivate = _numberCakeToReactivate;
        numberCakeToRegister = _numberCakeToRegister;
        numberCakeToUpdate = _numberCakeToUpdate;
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    /**
     * @dev To create a user profile. It sends the NFT to the contract
     * and sends CAKE to burn address. Requires 2 token approvals.
     */
    function createProfile(
        uint256 _teamId,
        address _nftAddress,
        uint256 _tokenId
    ) external {
        require(!hasRegistered[_msgSender()], "Already registered");
        require((_teamId <= numberTeams) && (_teamId > 0), "Invalid teamId");
        require(teams[_teamId].isJoinable, "Team not joinable");
        require(hasRole(NFT_ROLE, _nftAddress), "NFT address invalid");

        // Loads the interface to deposit the NFT contract
        IERC721 nftToken = IERC721(_nftAddress);

        require(
            _msgSender() == nftToken.ownerOf(_tokenId),
            "Only NFT owner can register"
        );

        // Transfer NFT to this contract
        nftToken.safeTransferFrom(_msgSender(), address(this), _tokenId);

        // Transfer CAKE tokens to this contract
        cakeToken.safeTransferFrom(
            _msgSender(),
            address(this),
            numberCakeToRegister
        );

        // Increment the _countUsers counter and get userId
        _countUsers.increment();
        uint256 newUserId = _countUsers.current();

        // Add data to the struct for newUserId
        users[_msgSender()] = User({
            userId: newUserId,
            numberPoints: 0,
            teamId: _teamId,
            nftAddress: _nftAddress,
            tokenId: _tokenId,
            isActive: true
        });

        // Update registration status
        hasRegistered[_msgSender()] = true;

        // Update number of active profiles
        numberActiveProfiles = numberActiveProfiles.add(1);

        // Increase the number of users for the team
        teams[_teamId].numberUsers = teams[_teamId].numberUsers.add(1);

        // Emit an event
        emit UserNew(_msgSender(), _teamId, _nftAddress, _tokenId);
    }

    /**
     * @dev To pause user profile. It releases the NFT.
     * Callable only by registered users.
     */
    function pauseProfile() external {
        require(hasRegistered[_msgSender()], "Has not registered");

        // Checks whether user has already paused
        require(users[_msgSender()].isActive, "User not active");

        // Change status of user to make it inactive
        users[_msgSender()].isActive = false;

        // Retrieve the teamId of the user calling
        uint256 userTeamId = users[_msgSender()].teamId;

        // Reduce number of active users and team users
        teams[userTeamId].numberUsers = teams[userTeamId].numberUsers.sub(1);
        numberActiveProfiles = numberActiveProfiles.sub(1);

        // Interface to deposit the NFT contract
        IERC721 nftToken = IERC721(users[_msgSender()].nftAddress);

        // tokenId of NFT redeemed
        uint256 redeemedTokenId = users[_msgSender()].tokenId;

        // Change internal statuses as extra safety
        users[_msgSender()].nftAddress = address(
            0x0000000000000000000000000000000000000000
        );

        users[_msgSender()].tokenId = 0;

        // Transfer the NFT back to the user
        nftToken.safeTransferFrom(address(this), _msgSender(), redeemedTokenId);

        // Emit event
        emit UserPause(_msgSender(), userTeamId);
    }

    /**
     * @dev To update user profile.
     * Callable only by registered users.
     */
    function updateProfile(address _nftAddress, uint256 _tokenId) external {
        require(hasRegistered[_msgSender()], "Has not registered");
        require(hasRole(NFT_ROLE, _nftAddress), "NFT address invalid");
        require(users[_msgSender()].isActive, "User not active");

        address currentAddress = users[_msgSender()].nftAddress;
        uint256 currentTokenId = users[_msgSender()].tokenId;

        // Interface to deposit the NFT contract
        IERC721 nftNewToken = IERC721(_nftAddress);

        require(
            _msgSender() == nftNewToken.ownerOf(_tokenId),
            "Only NFT owner can update"
        );

        // Transfer token to new address
        nftNewToken.safeTransferFrom(_msgSender(), address(this), _tokenId);

        // Transfer CAKE token to this address
        cakeToken.safeTransferFrom(
            _msgSender(),
            address(this),
            numberCakeToUpdate
        );

        // Interface to deposit the NFT contract
        IERC721 nftCurrentToken = IERC721(currentAddress);

        // Transfer old token back to the owner
        nftCurrentToken.safeTransferFrom(
            address(this),
            _msgSender(),
            currentTokenId
        );

        // Update mapping in storage
        users[_msgSender()].nftAddress = _nftAddress;
        users[_msgSender()].tokenId = _tokenId;

        emit UserUpdate(_msgSender(), _nftAddress, _tokenId);
    }

    /**
     * @dev To reactivate user profile.
     * Callable only by registered users.
     */
    function reactivateProfile(address _nftAddress, uint256 _tokenId) external {
        require(hasRegistered[_msgSender()], "Has not registered");
        require(hasRole(NFT_ROLE, _nftAddress), "NFT address invalid");
        require(!users[_msgSender()].isActive, "User is active");

        // Interface to deposit the NFT contract
        IERC721 nftToken = IERC721(_nftAddress);
        require(
            _msgSender() == nftToken.ownerOf(_tokenId),
            "Only NFT owner can update"
        );

        // Transfer to this address
        cakeToken.safeTransferFrom(
            _msgSender(),
            address(this),
            numberCakeToReactivate
        );

        // Transfer NFT to contract
        nftToken.safeTransferFrom(_msgSender(), address(this), _tokenId);

        // Retrieve teamId of the user
        uint256 userTeamId = users[_msgSender()].teamId;

        // Update number of users for the team and number of active profiles
        teams[userTeamId].numberUsers = teams[userTeamId].numberUsers.add(1);
        numberActiveProfiles = numberActiveProfiles.add(1);

        // Update user statuses
        users[_msgSender()].isActive = true;
        users[_msgSender()].nftAddress = _nftAddress;
        users[_msgSender()].tokenId = _tokenId;

        // Emit event
        emit UserReactivate(_msgSender(), userTeamId, _nftAddress, _tokenId);
    }

    /**
     * @dev To increase the number of points for a user.
     * Callable only by point admins
     */
    function increaseUserPoints(
        address _userAddress,
        uint256 _numberPoints,
        uint256 _campaignId
    ) external onlyPoint {
        // Increase the number of points for the user
        users[_userAddress].numberPoints = users[_userAddress].numberPoints.add(
            _numberPoints
        );

        emit UserPointIncrease(_userAddress, _numberPoints, _campaignId);
    }

    /**
     * @dev To increase the number of points for a set of users.
     * Callable only by point admins
     */
    function increaseUserPointsMultiple(
        address[] calldata _userAddresses,
        uint256 _numberPoints,
        uint256 _campaignId
    ) external onlyPoint {
        require(_userAddresses.length < 1001, "Length must be < 1001");
        for (uint256 i = 0; i < _userAddresses.length; i++) {
            users[_userAddresses[i]].numberPoints = users[_userAddresses[i]]
                .numberPoints
                .add(_numberPoints);
        }
        emit UserPointIncreaseMultiple(
            _userAddresses,
            _numberPoints,
            _campaignId
        );
    }

    /**
     * @dev To increase the number of points for a team.
     * Callable only by point admins
     */

    function increaseTeamPoints(
        uint256 _teamId,
        uint256 _numberPoints,
        uint256 _campaignId
    ) external onlyPoint {
        // Increase the number of points for the team
        teams[_teamId].numberPoints = teams[_teamId].numberPoints.add(
            _numberPoints
        );

        emit TeamPointIncrease(_teamId, _numberPoints, _campaignId);
    }

    /**
     * @dev To remove the number of points for a user.
     * Callable only by point admins
     */
    function removeUserPoints(address _userAddress, uint256 _numberPoints)
        external
        onlyPoint
    {
        // Increase the number of points for the user
        users[_userAddress].numberPoints = users[_userAddress].numberPoints.sub(
            _numberPoints
        );
    }

    /**
     * @dev To remove a set number of points for a set of users.
     */
    function removeUserPointsMultiple(
        address[] calldata _userAddresses,
        uint256 _numberPoints
    ) external onlyPoint {
        require(_userAddresses.length < 1001, "Length must be < 1001");
        for (uint256 i = 0; i < _userAddresses.length; i++) {
            users[_userAddresses[i]].numberPoints = users[_userAddresses[i]]
                .numberPoints
                .sub(_numberPoints);
        }
    }

    /**
     * @dev To remove the number of points for a team.
     * Callable only by point admins
     */

    function removeTeamPoints(uint256 _teamId, uint256 _numberPoints)
        external
        onlyPoint
    {
        // Increase the number of points for the team
        teams[_teamId].numberPoints = teams[_teamId].numberPoints.sub(
            _numberPoints
        );
    }

    /**
     * @dev To add a NFT contract address for users to set their profile.
     * Callable only by owner admins.
     */
    function addNftAddress(address _nftAddress) external onlyOwner {
        require(
            IERC721(_nftAddress).supportsInterface(0x80ac58cd),
            "Not ERC721"
        );
        grantRole(NFT_ROLE, _nftAddress);
    }

    /**
     * @dev Add a new teamId
     * Callable only by owner admins.
     */
    function addTeam(
        string calldata _teamName,
        string calldata _teamDescription
    ) external onlyOwner {
        // Verify length is between 3 and 16
        bytes memory strBytes = bytes(_teamName);
        require(strBytes.length < 20, "Must be < 20");
        require(strBytes.length > 3, "Must be > 3");

        // Increment the _countTeams counter and get teamId
        _countTeams.increment();
        uint256 newTeamId = _countTeams.current();

        // Add new team data to the struct
        teams[newTeamId] = Team({
            teamName: _teamName,
            teamDescription: _teamDescription,
            numberUsers: 0,
            numberPoints: 0,
            isJoinable: true
        });

        numberTeams = newTeamId;
        emit TeamAdd(newTeamId, _teamName);
    }

    /**
     * @dev Function to change team.
     * Callable only by special admins.
     */
    function changeTeam(address _userAddress, uint256 _newTeamId)
        external
        onlySpecial
    {
        require(hasRegistered[_userAddress], "User doesn't exist");
        require(
            (_newTeamId <= numberTeams) && (_newTeamId > 0),
            "teamId doesn't exist"
        );
        require(teams[_newTeamId].isJoinable, "Team not joinable");
        require(
            users[_userAddress].teamId != _newTeamId,
            "Already in the team"
        );

        // Get old teamId
        uint256 oldTeamId = users[_userAddress].teamId;

        // Change number of users in old team
        teams[oldTeamId].numberUsers = teams[oldTeamId].numberUsers.sub(1);

        // Change teamId in user mapping
        users[_userAddress].teamId = _newTeamId;

        // Change number of users in new team
        teams[_newTeamId].numberUsers = teams[_newTeamId].numberUsers.add(1);

        emit UserChangeTeam(_userAddress, oldTeamId, _newTeamId);
    }

    /**
     * @dev Claim CAKE to burn later.
     * Callable only by owner admins.
     */
    function claimFee(uint256 _amount) external onlyOwner {
        cakeToken.safeTransfer(_msgSender(), _amount);
    }

    /**
     * @dev Make a team joinable again.
     * Callable only by owner admins.
     */
    function makeTeamJoinable(uint256 _teamId) external onlyOwner {
        require((_teamId <= numberTeams) && (_teamId > 0), "teamId invalid");
        teams[_teamId].isJoinable = true;
    }

    /**
     * @dev Make a team not joinable.
     * Callable only by owner admins.
     */
    function makeTeamNotJoinable(uint256 _teamId) external onlyOwner {
        require((_teamId <= numberTeams) && (_teamId > 0), "teamId invalid");
        teams[_teamId].isJoinable = false;
    }

    /**
     * @dev Rename a team
     * Callable only by owner admins.
     */
    function renameTeam(
        uint256 _teamId,
        string calldata _teamName,
        string calldata _teamDescription
    ) external onlyOwner {
        require((_teamId <= numberTeams) && (_teamId > 0), "teamId invalid");

        // Verify length is between 3 and 16
        bytes memory strBytes = bytes(_teamName);
        require(strBytes.length < 20, "Must be < 20");
        require(strBytes.length > 3, "Must be > 3");

        teams[_teamId].teamName = _teamName;
        teams[_teamId].teamDescription = _teamDescription;
    }

    /**
     * @dev Update the number of CAKE to register
     * Callable only by owner admins.
     */
    function updateNumberCake(
        uint256 _newNumberCakeToReactivate,
        uint256 _newNumberCakeToRegister,
        uint256 _newNumberCakeToUpdate
    ) external onlyOwner {
        numberCakeToReactivate = _newNumberCakeToReactivate;
        numberCakeToRegister = _newNumberCakeToRegister;
        numberCakeToUpdate = _newNumberCakeToUpdate;
    }

    /**
     * @dev Check the user's profile for a given address
     */
    function getUserProfile(address _userAddress)
        external
        view
        returns (
            uint256,
            uint256,
            uint256,
            address,
            uint256,
            bool
        )
    {
        require(hasRegistered[_userAddress], "Not registered");
        return (
            users[_userAddress].userId,
            users[_userAddress].numberPoints,
            users[_userAddress].teamId,
            users[_userAddress].nftAddress,
            users[_userAddress].tokenId,
            users[_userAddress].isActive
        );
    }

    /**
     * @dev Check the user's status for a given address
     */
    function getUserStatus(address _userAddress) external view returns (bool) {
        return (users[_userAddress].isActive);
    }

    /**
     * @dev Check a team's profile
     */
    function getTeamProfile(uint256 _teamId)
        external
        view
        returns (
            string memory,
            string memory,
            uint256,
            uint256,
            bool
        )
    {
        require((_teamId <= numberTeams) && (_teamId > 0), "teamId invalid");
        return (
            teams[_teamId].teamName,
            teams[_teamId].teamDescription,
            teams[_teamId].numberUsers,
            teams[_teamId].numberPoints,
            teams[_teamId].isJoinable
        );
    }
}