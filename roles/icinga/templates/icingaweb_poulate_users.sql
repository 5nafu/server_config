INSERT INTO `icingaweb_group`
  (id, name, ctime)
VALUES
  (1,'Administrators',NOW())
ON DUPLICATE KEY UPDATE
  name=VALUES(name);

INSERT INTO `icingaweb_group_membership`
  (group_id, username, ctime)
VALUES
  (1,'snafu',NOW()),
  (1,'h0uz3',NOW())
ON DUPLICATE KEY UPDATE
  group_id=VALUES(group_id);

INSERT INTO `icingaweb_user`
  (name, active, password_hash, ctime)
VALUES
  ('h0uz3',1,'{{ icinga_default_passwords.h0uz3.password|password_hash('md5') }}',NOW()),
  ('snafu',1,'{{ icinga_default_passwords.snafu.password|password_hash('md5') }}',NOW())
ON DUPLICATE KEY UPDATE
  active=VALUES(active);
