import axios from "axios"
import { stringify } from "qs";
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


export const updateProductAtBackend = (product_id, updateObject, { onSuccess, onError }) => {
    axios({
        url: `${BASE_URL}products/superuser/${product_id}/`,
        method: 'PUT',
        headers: {
            'Authorization': localStorage.getItem('jwt'),
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        data: stringify(updateObject),
    }).then((res) => { onSuccess(res); }).catch((err) => { onError(err); });
}

export const updateCategoryAtBackend = (category_id, updateObject, { onSuccess, onError }) => {
    axios({
        url: `${BASE_URL}products/category/superuser/${category_id}/`,
        method: 'PUT',
        headers: {
            'Authorization': localStorage.getItem('jwt'),
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        data: stringify(updateObject),
    }).then((res) => { onSuccess(res); }).catch((err) => { onError(err); });
}