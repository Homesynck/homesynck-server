**Example compliant Node.js phone API using NEXMO**

```javascript
const Nexmo = require('nexmo');

const nexmo = new Nexmo({
  apiKey: process.env.NEXMO_KEY,
  apiSecret: process.env.NEXMO_SECRET
});

const express = require('express');
const app = express();

app.use(express.json());

const url = '/sms';

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Connected to ${ PORT }`);
});

const from = 'Homesynck';
const body = {
    status : ""
};
const homesynckKey = process.env.HOMESYNCK_SECRET;

app.post(url, async (req, res) => {
  const number = req.body.number
  const message = req.body.message
  const secret = req.body.secret

  if (secret == homesynckKey){
    const smsResponse = await rStatus(from, number, message);
    res.send(smsResponse.messages[0].status)
  }
});

function rStatus(from, number, message) { 
  return new Promise((resolve,reject) => {
    nexmo.message.sendSms(from, number, message, (error, response) => {
      if (error) return reject(error)
      return resolve(response)
    });
  });
}
```