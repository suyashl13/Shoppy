import axios from "axios"
import { BASE_URL } from "../Config"

export const loginAtBackend = async ({ phone, password, onSuccess, onError }) => {
    const formData = new FormData();
    formData.append('phone', phone)
    formData.append('password', password)

    await axios({
        method: 'POST',
        url: `${BASE_URL}users/subdealers/login/`,
        data: formData
    }).then(
        (e) => {
            localStorage.setItem('jwt', e.data.jwt);
            localStorage.setItem('phone', e.data.user.phone)
            onSuccess(e)
        }
    ).catch(
        (err) => {
            onError({ err });
        }
    )
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

export const createSubdealerAccAtBackend = async ({regFormData, onSuccess, onError}) => {
    const formData = new FormData();
    formData.append('is_subdealer', true)
    if (regFormData.password !== regFormData.confPassword) {
        return;
    }

    Object.keys(regFormData).forEach((val, attribute)=>{
        if (val !== 'confPassword') {
            if(regFormData[val] !== '') {
                formData.append(val, regFormData[val]);
            }
        }
    });

    await axios({
        url : `${BASE_URL}users/subdealers/`,
        method : 'POST',
        data : formData
    }).then(e=>{
        localStorage.setItem('phone', e.data.user.phone)
        localStorage.setItem('jwt', e.data.jwt)
        onSuccess(e.data)
    }).catch(err=>{
        onError({err})
    })

}