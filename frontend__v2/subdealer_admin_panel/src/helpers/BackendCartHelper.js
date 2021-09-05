import axios from "axios"
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