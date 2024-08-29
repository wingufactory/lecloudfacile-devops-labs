CREATE TABLE role_assignments (
    role_id INT,
    user_id INT DEFAULT NULL,
    group_id INT DEFAULT NULL,
    PRIMARY KEY (role_id, user_id, group_id),
    FOREIGN KEY (role_id) REFERENCES roles(role_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (group_id) REFERENCES groups(group_id),
    CHECK (user_id IS NOT NULL OR group_id IS NOT NULL)  -- Ensure that a role is assigned to either a user or a group
);
