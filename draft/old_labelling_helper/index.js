const express = require('express');
const app = express();

app.use('/', express.static('./public'))

app.listen(3331, () => {
    console.log('Server app listening on port 3331');
});