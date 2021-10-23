import axios from "axios";
import { stringify } from "qs";
import { BASE_URL } from "../config";

export const getSubdealerData = ({ onSuccess, onError }) => {
    const jwt = localStorage.getItem('jwt')

    if (!jwt) {
        onError("Unauthorized");
        return;
    }

    axios({
        url: `${BASE_URL}users/superuser/subdealers/`,
        method: 'GET',
        headers: {
            Authorization: jwt
        }
    }).then(e => {
        onSuccess(e);
    }).catch(err => {
        onError(err);
    })
}

export const updateSubdealerAtBackend = (subdealer_id, updateObject, { onSuccess, onError }) => {
    axios({
        url: `${BASE_URL}users/superuser/subdealers/${subdealer_id}/`,
        method: 'PUT',
        headers: {
            'Authorization': localStorage.getItem('jwt'),
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        data: stringify(updateObject),
    }).then((res) => { onSuccess(res); }).catch((err) => { onError(err); });
}