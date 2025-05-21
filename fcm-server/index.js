const express = require('express');
const admin = require('firebase-admin');
const cors = require('cors');
const app = express();
const port = 3000;

const serviceAccount = require('./chatapp-50195-firebase-adminsdk-fbsvc-05974dcc3b.json');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://chatapp-50195-default-rtdb.firebaseio.com"
});

app.use(cors({
    origin: '*',
    methods: ['GET', 'POST'],
    allowedHeaders: '*'
}));
app.use(express.json());

const authenticateRequest = (req, res, next) => {
    const apiKey = req.headers['x-api-key'];
    if (!apiKey || apiKey !== "NOTIFICATION_ANDROID_API_KEY") {
        return res.status(401).json({success: false, error: 'Unauthorized'});
    }
    next();
};

app.post('/send-notification', authenticateRequest, async (req, res) => {
    const {token, title, message, data} = req.body;
    const payload = {
        notification: {
            title: title,
            body: message,
        },
        data: data,
        token,
    };

    try {
        const response = await admin.messaging().send(payload);
        res.status(200).send({success: true, response});
    } catch (error) {
        res.status(500).send({success: false, error: error.message});
    }
});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
