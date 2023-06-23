const express = require('express');
const app = express();
const licenses = require('./licenses.json');

function encrypt(data, key) {
    let encoded = "";
    for (let i = 0; i < data.length; i++) {
        encoded += String.fromCharCode(data.charCodeAt(i) ^ key.charCodeAt(0));
    }
    return encoded;
}

app.get('/auth', (req, res) => {
    let value = req.headers['o'];
    let secret = req.headers['l'];
    let subsecret = req.headers['m'];
    let key = req.headers['productkey'];
    let timestamp = Math.floor(Date.now() / 1000);
    let userip = req.ip.replace('::ffff:', '');
    if (licenses[key] == undefined) {
        res.status(403).send('Invalid product key');
        return;
    } else if (!licenses[key].includes(userip)) {
        res.status(403).send('Invalid product key');
        return;
    }

    mathrelated = [
        {
            "k": 1,
            "n": encrypt('Authenticated', value + 'd' + key),
        },
        {
            "k": 2,
            "n": Math.ceil(value * secret / subsecret % timestamp + 7193)
        },
    ]
    res.send(mathrelated);
});

app.listen(8080, () => {
    console.log('Server started at http://localhost:8080');
});