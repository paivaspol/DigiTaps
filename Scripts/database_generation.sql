CREATE TABLE user (pid integer primary key);

CREATE TABLE event (eventId integer primary key,
                    eventType varchar(200),
                    gameId integer,
                    params varchar(500),
                    playerId integer,
                    taskId integer,
                    ts bigint);