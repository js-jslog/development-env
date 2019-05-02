const express = require('express')
const app = express()
const port = 3000

app.use(function (req, res, next) {
  console.log(`Incoming request from ${req.url}`);
});

app.get('/', (req, res) => res.send('Hello World!'))

app.listen(port, () => console.log(`Example app listening on port ${port}!`))

