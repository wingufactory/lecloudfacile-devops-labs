INSERT INTO users (user_id, username, email) VALUES
(1, 'k6sy', 'k6sy@lecloudfacile.com'),
(2, 'pmf', 'pmf@lecloudfacile.com'),
(3, 'syoum', 'syoum@lecloudfacile.com');

INSERT INTO roles (role_id, role_name) VALUES
(1, 'admin'),
(2, 'editor'),
(3, 'viewer');

INSERT INTO teams (team_id, team_name) VALUES
(1, 'developers'),
(2, 'devsecops'),
(3, 'managers');

INSERT INTO user_teams (user_id, team_id) VALUES
(1, 3),  -- k6sy in developers
(2, 2),  -- pmf in devsecops
(3, 1);  -- syoum in managers


INSERT INTO role_assignments (role_id, team_id) VALUES
(3, 1),  -- All developers as viewers
(2, 3);  -- All managers as editors
