function snowplowJobHelp ( playerid ) {
    local title = "job.snowplow.help.title";
    local commands = [
        { name = "job.snowplow.help.job",         desc = "job.snowplow.help.jobtext"           },
        { name = "job.snowplow.help.jobleave",    desc = "job.snowplow.help.jobleavetext"      }
    ];
    msg_help(playerid, title, commands);
}

cmd("help", "snowplow", snowplowJobHelp );
cmd("help", ["job", "snowplow"], snowplowJobHelp );
cmd("help", ["snowplow", "job"], snowplowJobHelp );
cmd("job", ["snowplow", "help"], snowplowJobHelp );
cmd("snowplow", ["job", "help"], snowplowJobHelp );
cmd("snowplow", snowplowJobHelp );
