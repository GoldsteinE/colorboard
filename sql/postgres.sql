DROP TABLE IF EXISTS "User";
CREATE TABLE IF NOT EXISTS "User"(
  "id" SERIAL NOT NULL,
  "color" text NOT NULL,
  "login" text NOT NULL,
  "passhash" text NOT NULL,
  PRIMARY KEY ("id"),
  UNIQUE ("color"),
  UNIQUE ("login")
);
DROP TABLE IF EXISTS "Session";
CREATE TABLE IF NOT EXISTS "Session"(
  "session_id" text NOT NULL,
  "session_data" text NOT NULL,
  UNIQUE ("session_id"),
  PRIMARY KEY ("session_id")
);
DROP TABLE IF EXISTS "Post";
CREATE TABLE IF NOT EXISTS "Post"(
  "id" SERIAL NOT NULL,
  "board_id" int NOT NULL,
  "author_id" int NOT NULL,
  "text" text NOT NULL,
  "timestamp" int NOT NULL,
  PRIMARY KEY ("id"),
  FOREIGN KEY ("board_id")
  REFERENCES "Board" ("id") ON DELETE CASCADE,
  FOREIGN KEY ("author_id")
  REFERENCES "User" ("id") ON DELETE CASCADE
);
DROP TABLE IF EXISTS "Board";
CREATE TABLE IF NOT EXISTS "Board"(
  "id" SERIAL NOT NULL,
  "name" text NOT NULL,
  "shortcut" text NOT NULL,
  "description" text NOT NULL,
  PRIMARY KEY ("id"),
  UNIQUE ("name"),
  UNIQUE ("shortcut")
);
