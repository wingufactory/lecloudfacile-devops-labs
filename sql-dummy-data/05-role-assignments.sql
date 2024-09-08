CREATE TABLE role_assignments (
    role_id INT,
    team_id INT,
    PRIMARY KEY (role_id, team_id),
    FOREIGN KEY (role_id) REFERENCES roles(role_id),
    FOREIGN KEY (team_id) REFERENCES teams(team_id)
);
