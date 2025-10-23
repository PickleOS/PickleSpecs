const express = require('express');
const axios = require('axios');
const crypto = require('crypto');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

// ==========================================
// CONFIGURACIÓN - Tu bot de Telegram
// ==========================================

const CONFIG = {
    BOT_TOKEN: '8273006409:AAHCPMaUvlfc9BgRzElyIfT3eih5EN8i3rs',
    CHAT_ID: '-1003120256788',
    BOT_USERNAME: 'iSoyPickle_bot'
};

// ==========================================
// MIDDLEWARE
// ==========================================

app.use(cors());
app.use(express.json());

app.use((req, res, next) => {
    console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
    next();
});

// ==========================================
// FUNCIONES
// ==========================================

function verifyTelegramAuth(authData, botToken) {
    const { hash, ...data } = authData;
    const dataCheckString = Object.keys(data)
        .sort()
        .map(key => `${key}=${data[key]}`)
        .join('\n');
    const secretKey = crypto.createHash('sha256').update(botToken).digest();
    const hmac = crypto.createHmac('sha256', secretKey).update(dataCheckString).digest('hex');
    return hmac === hash;
}

async function checkMembership(userId, chatId, botToken) {
    try {
        const url = `https://api.telegram.org/bot${botToken}/getChatMember`;
        const response = await axios.post(url, {
            chat_id: chatId,
            user_id: userId
        });
        const status = response.data.result.status;
        const validStatuses = ['creator', 'administrator', 'member'];
        return validStatuses.includes(status);
    } catch (error) {
        console.error('Error al verificar membresía:', error.response?.data || error.message);
        throw error;
    }
}

// ==========================================
// ENDPOINTS
// ==========================================

app.get('/', (req, res) => {
    res.json({
        status: 'ok',
        message: 'Servidor de verificación Telegram activo',
        bot: CONFIG.BOT_USERNAME,
        timestamp: new Date().toISOString()
    });
});

app.post('/verify-membership', async (req, res) => {
    try {
        const userData = req.body;
        console.log('Verificando usuario:', userData.id, userData.username);
        
        const isValidAuth = verifyTelegramAuth(userData, CONFIG.BOT_TOKEN);
        
        if (!isValidAuth) {
            console.log('❌ Autenticación inválida');
            return res.status(401).json({
                success: false,
                message: 'Autenticación inválida'
            });
        }
        
        console.log('✅ Autenticación válida');
        
        const isMember = await checkMembership(userData.id, CONFIG.CHAT_ID, CONFIG.BOT_TOKEN);
        
        if (isMember) {
            console.log('✅ Usuario es miembro del grupo');
            return res.json({
                success: true,
                isMember: true,
                message: 'Acceso concedido',
                user: {
                    id: userData.id,
                    name: userData.first_name,
                    username: userData.username
                }
            });
        } else {
            console.log('❌ Usuario NO es miembro del grupo');
            return res.json({
                success: true,
                isMember: false,
                message: 'No eres miembro del grupo. Únete al grupo y vuelve a intentar.'
            });
        }
    } catch (error) {
        console.error('Error:', error);
        return res.status(500).json({
            success: false,
            message: 'Error al verificar membresía'
        });
    }
});

// ==========================================
// INICIAR
// ==========================================

app.listen(PORT, () => {
    console.log('==========================================');
    console.log('🚀 Servidor iniciado');
    console.log(`📡 Puerto: ${PORT}`);
    console.log(`🤖 Bot: ${CONFIG.BOT_USERNAME}`);
    console.log(`👥 Chat ID: ${CONFIG.CHAT_ID}`);
    console.log('==========================================');
    console.log('✅ Listo para recibir peticiones');
});

module.exports = app;
