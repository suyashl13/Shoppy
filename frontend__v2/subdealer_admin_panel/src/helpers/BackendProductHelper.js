import axios from "axios"
import { stringify } from "qs"
import { BASE_URL } from "../Config"

export const getProductsFromBackend = async ({ onSuccess, onError }) => {
    await axios({
        url: BASE_URL + 'products/subdealers/',
        method: 'GET',
        headers: {
            'Authorization': localStorage.getItem('jwt')
        }
    }).then(e => {
        onSuccess(e.data)
    }).catch(err => {
        onError({ err })
    })
}

export const updateProductAtBackend = async ({ onSuccess, onError }, productId, updateObject) => {
    await axios({
        url: `${BASE_URL}products/subdealers/${productId}/`,
        method: 'PUT',
        headers: {
            'Authorization': localStorage.getItem('jwt'),
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        data: stringify(updateObject)
    }).then((e) => {
        if (e.status == 200) { onSuccess(e.data); }
    }).catch((err) => { onError({ err }) })
}

export const addProductAtBackend = async ({ onSuccess, onError }, newProduct) => {

    const newProductData = new FormData()

    Object.keys(newProduct).forEach(key => {
        newProductData.append(key, newProduct[key]);
    })

    await axios({
        url: `${BASE_URL}products/subdealers/`,
        method: 'POST',
        headers: { 'Authorization': localStorage.getItem('jwt'), },
        data: newProductData,
    }).then(e => {
        if (e.status == 200) {
            onSuccess(e.data);
        }
    }).catch(err => {onError({err})})
}