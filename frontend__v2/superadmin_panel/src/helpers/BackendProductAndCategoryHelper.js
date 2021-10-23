import axios from "axios"
import { BASE_URL } from "../config"

export const getProductsAndCategories = ({ onSuccess, onError }) => {

    const jwt = localStorage.getItem('jwt')

    if (!jwt) {
        onError('Unauthorized');
        return;
    }

    axios({
        url: `${BASE_URL}products/superuser/`,
        method: 'GET',
        headers: {
            Authorization: jwt
        }
    }).then((e) => {
        onSuccess(e);
    }).catch(err => {
        onError(err);
    })
}