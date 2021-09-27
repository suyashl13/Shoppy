import axios from "axios"
import { BASE_URL } from "../config";

export const createAccountAtBackend = async ({ onSuccess, onError }, data) => {
    const formData = new FormData();

    Object.keys(data).forEach((key, _) => {
        formData.append(key, data[key]);
    });

    await axios({
        method: 'POST',
        data: data,
        url: `${BASE_URL}users/channel_partner/`,
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
