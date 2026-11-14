CREATE EXTENSION IF NOT EXISTS pgcrypto -- generate random uuid
--Enums--
CREATE TYPE user_role AS ENUM ('ADMIN', 'ENUMERATOR', 'ANALYST');
CREATE TYPE survey_status AS ENUM('DRAFT','PUBLISHED','CLOSED');
CREATE TYPE question_type AS ENUM('TEXT','NUMBER','SINGLE_CHOICE','MULTI_CHOICE','DATE');

-- Users --

CREATE TABLE app_user(
                         id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                         email VARCHAR(255) NOT NULL UNIQUE ,
                         full_name VARCHAR(255) NOT NULL ,
                         password_hash VARCHAR(255) NOT NULL , --bcrypt/argon2, never plain text
                         role user_role NOT NULL ,
                         active BOOLEAN NOT NULL DEFAULT TRUE,
                         created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

--Survey

CREATE TABLE survey(
                       id UUID PRIMARY KEY  DEFAULT gen_random_uuid(),
                       title VARCHAR(255) NOT NULL ,
                       description TEXT,
                       status survey_status NOT NULL DEFAULT 'DRAFT',
                       created_by UUID NOT NULL REFERENCES app_user(id),
                       created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
                       updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
                       deleted_at TIMESTAMPTZ
);

--Survey Version
CREATE TABLE survey_version(
                               id UUID NOT NULL DEFAULT gen_random_uuid(),
                               survey_id UUID NOT NULL REFERENCES survey(id) ON DELETE CASCADE,
                               version_no INT NOT NULL CHECK ( version_no >0 ),
                               published_at TIMESTAMPTZ,
                               created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
                               UNIQUE (survey_id,version_no)
);