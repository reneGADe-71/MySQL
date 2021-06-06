DROP DATABASE IF EXISTS vk;
CREATE DATABASE IF NOT EXISTS vk;

USE vk;

CREATE TABLE users(
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(150) NOT NULL,
    last_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash CHAR(80) DEFAULT NULL, 
    phone CHAR(11) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX users_email_idx (email),
    UNIQUE INDEX users_phone_unique_idx (phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE profiles(
    user_id SERIAL PRIMARY KEY,
    gender ENUM('f', 'm', 'x'),
    birthday DATE NOT NULL,
    photo_id BIGINT UNSIGNED,
    city VARCHAR(130), 
    country VARCHAR(130),
    FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE media_types (
	id SERIAL PRIMARY KEY,
	name VARCHAR(200) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE media (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	media_types_id BIGINT UNSIGNED NOT NULL,
	file_name VARCHAR(200),
	file_size BIGINT UNSIGNED,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	INDEX media_media_types_idx (media_types_id),
  	INDEX media_users_idx (user_id),
  	FOREIGN KEY (media_types_id) REFERENCES media_types(id),
  	CONSTRAINT fk_media_users FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE messages (
	id SERIAL PRIMARY KEY,
	from_user_id BIGINT UNSIGNED NOT NULL,
	to_user_id BIGINT UNSIGNED NOT NULL,
	txt TEXT NOT NULL,
	is_delivered BOOL DEFAULT false,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	KEY (from_user_id),
	KEY (to_user_id),
	CONSTRAINT fk_messages_users_1 FOREIGN KEY (from_user_id) REFERENCES users (id),
	CONSTRAINT fk_messages_users_2 FOREIGN KEY (to_user_id) REFERENCES users (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE friend_requests (
  from_user_id BIGINT UNSIGNED NOT NULL,
  to_user_id BIGINT UNSIGNED NOT NULL,
  accepted BOOLEAN DEFAULT False,
  PRIMARY KEY (from_user_id, to_user_id),
  KEY (from_user_id),
  KEY (to_user_id),
  CONSTRAINT fk_friend_requests_users_1 FOREIGN KEY (from_user_id) REFERENCES users (id),
  CONSTRAINT fk_friend_requests_users_2 FOREIGN KEY (to_user_id) REFERENCES users (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE communities (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(145) NOT NULL,
  description VARCHAR(245) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE communities_users (
	community_id BIGINT UNSIGNED NOT NULL,
	user_id BIGINT UNSIGNED NOT NULL,
	PRIMARY KEY (community_id, user_id),
	KEY (community_id),
  	KEY (user_id),
  	CONSTRAINT fk_communities_users_comm FOREIGN KEY (community_id) REFERENCES communities (id),
  	CONSTRAINT fk_communities_users_users FOREIGN KEY (user_id) REFERENCES users (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE post (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED,
	body TEXT,
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT NOW(),
	FOREIGN KEY (user_id) REFERENCES users(id),
	INDEX (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE likes_post(
	id SERIAL PRIMARY KEY,
	post_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (post_id) REFERENCES post(id),
    UNIQUE INDEX (post_id, user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE likes_media(
	id SERIAL PRIMARY KEY,
	media_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_id) REFERENCES media(id),
    UNIQUE INDEX (media_id, user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE likes_user(
	id SERIAL PRIMARY KEY,
	profiles_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (profiles_id) REFERENCES profiles(user_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    UNIQUE INDEX (profiles_id, user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO media_types VALUES (DEFAULT, 'image');
INSERT INTO media_types VALUES (DEFAULT, 'music');
INSERT INTO media_types VALUES (DEFAULT, 'document');

INSERT INTO users VALUES (DEFAULT, 'Petya', 'Petukhov', 'petya@mail.com', DEFAULT, '89212223333', DEFAULT);
INSERT INTO users VALUES (DEFAULT, 'Vasya', 'Vasilkov', 'vasya@mail.com', DEFAULT, '89212223334', DEFAULT);

INSERT INTO profiles VALUES (1, 'm', '1997-12-01', NULL, 'Moscow', 'Russia');
INSERT INTO profiles VALUES (2, 'm', '1988-11-02', NULL, 'Moscow', 'Russia');

INSERT INTO messages VALUES (DEFAULT, 1, 2, 'Hi!', 1, DEFAULT, DEFAULT);
INSERT INTO messages VALUES (DEFAULT, 1, 2, 'Vasya!', 1, DEFAULT, DEFAULT);
INSERT INTO messages VALUES (DEFAULT, 2, 1, 'Hi, Petya', 1, DEFAULT, DEFAULT);

INSERT INTO friend_requests VALUES (1, 2, 1);

INSERT INTO communities VALUES (DEFAULT, 'Number1', 'I am number one');

INSERT INTO communities_users VALUES (1, 2);

INSERT INTO media VALUES (DEFAULT, 1, 1, 'im.jpg', 100, DEFAULT);
INSERT INTO media VALUES (DEFAULT, 1, 1, 'im1.png', 78, DEFAULT);

INSERT INTO media VALUES (DEFAULT, 2, 3, 'doc.docx', 1024, DEFAULT);

INSERT INTO post VALUES (DEFAULT, 1, 'News', DEFAULT, DEFAULT);

INSERT INTO likes_post VALUES (DEFAULT, 1, 2, DEFAULT);

INSERT INTO likes_user VALUES (DEFAULT, 2, 1, DEFAULT);

ALTER TABLE users ADD COLUMN passport_number VARCHAR(10);

ALTER TABLE users MODIFY COLUMN passport_number VARCHAR(20);

ALTER TABLE users RENAME COLUMN passport_number TO passport;

ALTER TABLE users ADD KEY passport_idx (passport);

ALTER TABLE users DROP INDEX passport_idx;

ALTER TABLE users DROP COLUMN passport;

ALTER TABLE friend_requests 
ADD CONSTRAINT sender_not_reciever_check 
CHECK (from_user_id != to_user_id);

ALTER TABLE users 
ADD CONSTRAINT phone_check
CHECK (REGEXP_LIKE(phone, '^[0-9]{11}$'));

DESCRIBE users;
