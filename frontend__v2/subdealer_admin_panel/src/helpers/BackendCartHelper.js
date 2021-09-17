import axios from "axios"
import { stringify } from "qs"
import { BASE_URL } from "../Config"

export const getDeliveralbleOrders = async ({ onSuccess, onError }) => {
    await axios({
        url: `${BASE_URL}carts/subdealers/`,
        method: 'GET',
        headers: { 'Authorization': localStorage.getItem('jwt') },
    }).then(e => {
        if (e.status === 200) {
            onSuccess(e.data)
        }
    }).catch(err => {
        onError(err);
    })
}

export const assignDeliveryToStaffAtBackend = async (cartId, updatedOrder, { onSuccess, onError }) => {
    await axios({
        url: `${BASE_URL}carts/subdealers/${cartId}/`,
        method: 'PUT',
        headers: {
            'Authorization': localStorage.getItem('jwt'),
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        data: stringify(updatedOrder)
    }).then(e => {
        onSuccess(e.data)
    })
        .catch(err => {
            onError({ err })
        })
}

export const assignDeliveryToCourierAtBackend = async (cartId, orderData, { onSuccess, onError }) => {
    
    const formData = new FormData();
    Object.keys(orderData).map(element => {
        formData.append(element, orderData[element]);
    });

    await axios({
        url: `${BASE_URL}carts/subdealers/courier_delivery/${cartId}/`,
        method: "POST",
        headers: { 'Authorization': localStorage.getItem('jwt'), },
        data: formData
    }).then(res=>{
        if (res.status == 200) {
            onSuccess(res.data)
        }
    }).catch(err=> {
        onError({err})
    })
}