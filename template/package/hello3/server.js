import Fs from 'fs';
import Path from 'path';
import Express from 'express';
import Morgan from 'morgan';
const app = Express();
const port = 8080;
// const files = [
//   'target/scala-3.0.0-M2/hello3-fastopt/hello3.js',
//   'target/scala-3.0.0-M2/hello3-fastopt/hello3.js.map'
// ];

// for (let file of files) {
//   if (!Fs.existsSync(file)) {
//     console.error('no file: ' + file);
//     process.exit(1);
//   }
//   Fs.copyFileSync(file, Path.join('./web', Path.basename(file)));
// }

// app.use(Morgan('combined', { stream: Fs.createWriteStream(Path.join('log', 'access.log')) }));
app.use(Morgan('tiny'));

// app.get('/index', (req, res) => res.sendFile(__dirname + '/index.html'));
app.use(Express.static(Path.resolve('./web')));
app.use('/src/', Express.static(Path.resolve('./src')));

app.get('/hello', (req, res) => {
  res.send('Hello World!')
});

app.listen(port, '0.0.0.0', () => {
  console.log(`Listening at http://0.0.0.0:${port}`);
});
