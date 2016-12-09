var express = require('express')
var app     = express()

// import the discord.js module
const Discord = require('discord.js');

// create a new webhook
const hook = new Discord.WebhookClient('254996161293844482', 'L21kxfcPeSIDZKK2dxRkp_g37IHkvBcpbn-JVepv5yeA11BT88Ubz7IjHs9PE-jxj2OZ');

// send a message using the webhook

// var discordurl = "https://discordapp.com/api/webhooks/254996161293844482/L21kxfcPeSIDZKK2dxRkp_g37IHkvBcpbn-JVepv5yeA11BT88Ubz7IjHs9PE-jxj2OZ";

// POST method route
app.get('/discord', function (req, res) {
    let data    = req.query.data;
    let type    = req.query.type.toUpperCase();
    let message = new Buffer(data, 'base64').toString('utf8');

    hook.sendMessage(`[${type}] ${message}`);
    res.send('true');
})

app.listen(7790, function() {
    console.log('Example app listening on port 3000!')
})
