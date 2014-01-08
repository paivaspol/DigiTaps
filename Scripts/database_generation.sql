CREATE TABLE players (pid integer primary key, age integer, gender integer, possession integer, identity integer, usage integer);

CREATE TABLE event (eventId integer primary key,
                    eventType varchar(200),
                    gameId integer,
                    params varchar(500),
                    playerId integer,
                    taskId integer,
                    ts bigint);