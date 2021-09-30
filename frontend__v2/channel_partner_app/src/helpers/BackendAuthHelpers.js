import axios from "axios"
import { BASE_URL } from "../config";

export const createAccountAtBackend = async ({ onSuccess, onError }, data) => {
    const formData = new FormData();

    Object.keys(data).forEach((key, _) => {
        formData.append(key, data[key]);
    });

    await axios({
        method: 'POST',
        data: formData,
        url: `${BASE_URL}users/channel_partners/`,
    }).then(e => {
        if (e.status === 200) {
            localStorage.setItem('phone', e.data.user.phone);
            localStorage.setItem('jwt', e.data.jwt);
            onSuccess(e.data);
        }
    }).catch(err => {
        onError({ err });
    })
}

export const checkAuthSession = async () => {
    if (!(localStorage.getItem('jwt') && localStorage.getItem('phone'))) {
        return false;
    }

    let res = null;

    await axios({
        url: `${BASE_URL}users/check_session/${localStorage.getItem('phone')}/`,
        method: 'get',
        headers: { 'Authorization': localStorage.getItem('jwt') },
    }).then(e => {
        if (e.status === 200) {
            res = e.data.exists
        }
    })
        .catch((err) => {
            res = false;
        })
    return res;
}


export const logoutAtBackend = async ({ onSuccess, onError }) => {
    await axios({
        url: `${BASE_URL}users/logout/`,
        method: 'GET',
        headers: { 'Authorization': localStorage.getItem('jwt') },
    }).then(e => {
        onSuccess()
    }).catch(err => {
        onError({ err });
    })
}

export const loginAtBackend = async ({ onSuccess, onError }, { phone, password }) => {

    const formData = new FormData()
    formData.append('phone', phone)
    formData.append('password', password)

    await axios({
        method: "POST",
        url: `${BASE_URL}users/channel_partners/login/`,
        data: formData,
    }).then(e => {
        localStorage.setItem('jwt', e.data.jwt)
        localStorage.setItem('phone', e.data.user.phone)
        onSuccess(e.data)
    }).catch(err => {
        onError({ err })
    })
}