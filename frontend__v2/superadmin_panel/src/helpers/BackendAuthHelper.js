import axios from "axios"
import { BASE_URL } from "../config"

export const checkAuthAtBackend = async ({
    onSuccess, onError
}) => {
    if (!(localStorage.getItem('jwt') && localStorage.getItem('phone'))) {
        onSuccess(false);
        return;
    }

    try {
        const authResult = await axios({
            url: `${BASE_URL}users/check_session/${localStorage.getItem('phone')}/`,
            headers: { Authorization: localStorage.getItem('jwt') }
        })
        onSuccess(authResult.data.exists);
    } catch (error) {
        onError(error.message)
    }
}

export const loginAtBackend = (credentials, { onSuccess, onError }) => {
    const loginCredentials = new FormData();
    Object.keys(credentials).forEach((key) => {
        loginCredentials.set(key, credentials[key]);
    });

    axios({
        url: `${BASE_URL}users/login/`,
        method: 'POST',
        data: loginCredentials
    }).then((e) => {
        localStorage.setItem('phone', e.data.user?.phone)
        localStorage.setItem('jwt', e.data.jwt)
        onSuccess(e)
    }).catch(err => {
        onError({ err });
    })

}