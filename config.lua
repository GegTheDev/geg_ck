Config = {
	Framework = "esx", -- "auto", "esx", "old-esx" or "qbcore"

	EnableCheckIdentifiers = true, -- This will check if the user has any of these identifiers before performing CK.
	CheckIdentifiers = {
		"char1:2f0fe9b4d0e8e53d06031cadd9b791d08f36d727",
	},

	EnablePermissions = false, -- This will check if the user has an admin group before performing CK.
	AdminGroups = {
		"admin",
	},

	CKCommand = "ck", -- Command for admins to CK a player.

	-- User tables to delete. Key = Table name, Value = Column name.
	-- Example: Table "users", Column "identifier"

	--[[ The script will check for the player identifier in the given column.
	     If your database works differently, you can modify this as needed. ]]
	TablesToDelete = {
		["users"] = "identifier",
		["owned_vehicles"] = "owner"
	},

	CkMessage = "[geg_ck]: You have been CKed. Please restart FiveM", -- Message shown when dropping a player after CK.

	ChatMessageFormats = {
		colors = {255, 0, 0}, -- Chat message color (RGB)
		prefix = "[geg_ck]", -- Set to nil if you don't want a prefix in chat messages.
		messageSuccess = "CK successful!",
		messageUnknownPlayer = "Unknown player (maybe they aren't loaded in?)",
		messageInvalidPlayerId = "You need to put a valid player ID",
		messageNoPermissions = "You can't execute this command!"
	}
}