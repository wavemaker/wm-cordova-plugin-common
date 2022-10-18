var fs = require('fs');

var projectDir = __dirname + '/../../../../';
const barcodescannerGradlePath = `${projectDir}/platforms/android/phonegap-plugin-barcodescanner`;

const migration = () => {
    if (fs.existsSync(barcodescannerGradlePath)) {
        fs.readdirSync(barcodescannerGradlePath).map(file => {
            if (file.endsWith('.gradle')) {
                const filePath = barcodescannerGradlePath + '/' + file;
                let text = fs.readFileSync(filePath, "utf-8");
                if (text) {
                    text = text.replace(/compile\(/g, 'implementation(');
                    fs.writeFileSync(filePath, text);
                    console.log('migrated barcode scanner gradle : ' + filePath);
                }
            }
        });
    }
    console.log('migrated for cordova-android 11.0.0.');
};
module.exports = migration;