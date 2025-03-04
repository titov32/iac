const express = require('express');
const os = require('os');

const app = express();
const PORT = 5000;

app.get('/', (req, res) => {
    const hostname = os.hostname();
    const ip_address = req.ip;
    res.json({ hostname, ip_address });
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server is running on port ${PORT}`);
});
