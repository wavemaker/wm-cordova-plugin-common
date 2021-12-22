var fs = require('fs-extra');
const et = require('elementtree');

var projectDir = __dirname + '/../../../../';

function getServerDomain() {
    var configJSON = JSON.parse(fs.readFileSync(projectDir + '/www/config.json').toString());
    var baseUrl = configJSON.baseUrl;
    var domain = null;
    if (configJSON.useNativeXHR !== true && baseUrl && baseUrl.indexOf('://')) {
        domain = baseUrl.substring(baseUrl.indexOf('://') + 3);
        if (domain.indexOf('/') >= 0) {
            domain = domain.substring(0, domain.indexOf('/'));
        } 
    }
    return domain;
}

function isHttps() {
    var configJSON = JSON.parse(fs.readFileSync(projectDir + '/www/config.json').toString());
    return configJSON.baseUrl.indexOf('https://') === 0;
}

function addPreferences(context) {
    var configXML = et.parse(fs.readFileSync(projectDir + '/config.xml').toString());
    var android = configXML.getroot().findall('./platform[@name="android"]')[0];
    var hostPreference = android.findall('./preference[@name="hostname"]') || [];
    var domain = getServerDomain();
    if (domain && hostPreference.length === 0) {
        android.append(new et.Element('preference', {
            'name': 'hostname',
            'value': getServerDomain()
        }));
        android.append(new et.Element('preference', {
            'name': 'scheme',
            'value': isHttps() ? 'https': 'http'
        }));
        const modifiedConfigXML = et.tostring(configXML.getroot());
        console.log(modifiedConfigXML);
        fs.writeFileSync(projectDir + '/config.xml', modifiedConfigXML)
    }
}

module.exports = addPreferences;