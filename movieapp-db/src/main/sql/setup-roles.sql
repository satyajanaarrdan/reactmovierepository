-- Copyright 2018-2019, https://beingtechie.io

-- Script: db-setup-roles.sql
-- Description: Create roles and permissions specific tables and grant privileges
-- Version: 1.0
-- Author: Thribhuvan Krishnamurthy

-- # Step 1 - GROUPS table
DROP TABLE IF EXISTS movieapp.GROUPS CASCADE;
CREATE TABLE IF NOT EXISTS movieapp.GROUPS (
	ID SMALLSERIAL PRIMARY KEY,
	UUID SMALLINT NOT NULL,
	NAME VARCHAR(50) NOT NULL,
	DESCRIPTION VARCHAR(200),
	CREATED_BY VARCHAR(100) NOT NULL DEFAULT CURRENT_USER,
	CREATED_AT TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE movieapp.GROUPS IS 'Table to capture groups';
COMMENT ON COLUMN movieapp.GROUPS.ID IS 'Auto generated PK identifier';
COMMENT ON COLUMN movieapp.GROUPS.UUID IS 'Unique identifier used as reference by external systems';
COMMENT ON COLUMN movieapp.GROUPS.NAME IS 'Unique name of the group';
COMMENT ON COLUMN movieapp.GROUPS.DESCRIPTION IS 'Description of the group';
COMMENT ON COLUMN movieapp.GROUPS.CREATED_BY IS 'User who inserted this record';
COMMENT ON COLUMN movieapp.GROUPS.CREATED_AT IS 'Point in time when this record was inserted';

ALTER TABLE movieapp.GROUPS OWNER TO postgres;
ALTER TABLE movieapp.GROUPS ADD CONSTRAINT UK_GROUPS_UUID UNIQUE(UUID);

-- # Step 2 - PERMISSIONS table
DROP TABLE IF EXISTS movieapp.PERMISSIONS;
CREATE TABLE IF NOT EXISTS movieapp.PERMISSIONS (
	ID SMALLSERIAL PRIMARY KEY,
	UUID SMALLINT NOT NULL,
	GROUP_ID SMALLINT NOT NULL,
	NAME VARCHAR(50) NOT NULL,
	DESCRIPTION VARCHAR(200),
	CREATED_BY VARCHAR(100) NOT NULL DEFAULT CURRENT_USER,
	CREATED_AT TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE movieapp.PERMISSIONS IS 'Table to define permissions mapped to a group';
COMMENT ON COLUMN movieapp.PERMISSIONS.ID IS 'Auto generated PK identifier';
COMMENT ON COLUMN movieapp.PERMISSIONS.UUID IS 'Unique identifier used as reference by external systems';
COMMENT ON COLUMN movieapp.PERMISSIONS.GROUP_ID IS 'Group that this permission is mapped to';
COMMENT ON COLUMN movieapp.PERMISSIONS.NAME IS 'Unique name of the permission';
COMMENT ON COLUMN movieapp.PERMISSIONS.DESCRIPTION IS 'Description of the permission';
COMMENT ON COLUMN movieapp.PERMISSIONS.CREATED_BY IS 'User who inserted this record';
COMMENT ON COLUMN movieapp.PERMISSIONS.CREATED_AT IS 'Point in time when this record was inserted';

ALTER TABLE movieapp.PERMISSIONS OWNER TO postgres;
ALTER TABLE movieapp.PERMISSIONS ADD CONSTRAINT UK_PERMISSIONS_UUID UNIQUE(UUID);
ALTER TABLE movieapp.PERMISSIONS ADD CONSTRAINT FK_PERMISSIONS_GROUP_ID FOREIGN KEY(GROUP_ID) REFERENCES movieapp.GROUPS(ID);

-- # Step 3 - ROLES table
DROP TABLE IF EXISTS movieapp.ROLES;
CREATE TABLE IF NOT EXISTS movieapp.ROLES (
   ID SMALLSERIAL PRIMARY KEY,
   UUID SMALLINT NOT NULL,
   VERSION SERIAL NOT NULL,
   NAME VARCHAR(50) NOT NULL,
   DESCRIPTION VARCHAR(200),
   ACTIVE BOOLEAN NOT NULL,
   CREATED_BY VARCHAR(100) NOT NULL DEFAULT CURRENT_USER,
   CREATED_AT TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   MODIFIED_BY VARCHAR(100),
   MODIFIED_AT TIMESTAMP
);
COMMENT ON TABLE movieapp.ROLES IS 'Table to define roles';
COMMENT ON COLUMN movieapp.ROLES.ID IS 'Auto generated PK identifier';
COMMENT ON COLUMN movieapp.ROLES.UUID IS 'Unique identifier used as reference by external systems';
COMMENT ON COLUMN movieapp.ROLES.VERSION IS 'Versioning for optimistic locking';
COMMENT ON COLUMN movieapp.ROLES.NAME IS 'Unique name of the role';
COMMENT ON COLUMN movieapp.ROLES.DESCRIPTION IS 'Description of the role';
COMMENT ON COLUMN movieapp.ROLES.ACTIVE IS 'Active status of the role - INACTIVE(0), ACTIVE (1)';
COMMENT ON COLUMN movieapp.ROLES.CREATED_BY IS 'User who inserted this record';
COMMENT ON COLUMN movieapp.ROLES.CREATED_AT IS 'Point in time when this record was inserted';
COMMENT ON COLUMN movieapp.ROLES.MODIFIED_BY IS 'User who modified this record';
COMMENT ON COLUMN movieapp.ROLES.MODIFIED_AT IS 'Point in time when this record was modified';

ALTER TABLE movieapp.ROLES OWNER TO postgres;
ALTER TABLE movieapp.ROLES ADD CONSTRAINT UK_ROLES_UUID UNIQUE(UUID);
ALTER TABLE movieapp.ROLES ADD CONSTRAINT UK_ROLES_NAME UNIQUE(NAME);

-- # Step 4 - ROLE_PERMISSIONS table
DROP TABLE IF EXISTS movieapp.ROLE_PERMISSIONS CASCADE;
CREATE TABLE IF NOT EXISTS movieapp.ROLE_PERMISSIONS (
   ID SMALLSERIAL PRIMARY KEY,
   ROLE_ID SMALLINT NOT NULL,
   PERMISSION_ID SMALLINT NOT NULL,
   CREATED_BY VARCHAR(100) NOT NULL DEFAULT CURRENT_USER,
   CREATED_AT TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE movieapp.ROLE_PERMISSIONS IS 'Table to define role and permissions mapping';
COMMENT ON COLUMN movieapp.ROLE_PERMISSIONS.ID IS 'Auto generated PK identifier';
COMMENT ON COLUMN movieapp.ROLE_PERMISSIONS.ROLE_ID IS 'Role that has permissions mapped';
COMMENT ON COLUMN movieapp.ROLE_PERMISSIONS.PERMISSION_ID IS 'Permission mapped to the role';
COMMENT ON COLUMN movieapp.ROLES.CREATED_BY IS 'User who inserted this record';
COMMENT ON COLUMN movieapp.ROLES.CREATED_AT IS 'Point in time when this record was inserted';

ALTER TABLE movieapp.ROLE_PERMISSIONS OWNER TO postgres;
ALTER TABLE movieapp.ROLE_PERMISSIONS ADD CONSTRAINT FK_ROLE_PERMISSIONS_ROLE_ID FOREIGN KEY(ROLE_ID) REFERENCES movieapp.ROLES(ID);
ALTER TABLE movieapp.ROLE_PERMISSIONS ADD CONSTRAINT FK_ROLE_PERMISSIONS_PERMISSION_ID FOREIGN KEY(PERMISSION_ID) REFERENCES movieapp.PERMISSIONS(ID);

-- # Step 5 - Commit Transaction
COMMIT;

-- ********** End of setup **********