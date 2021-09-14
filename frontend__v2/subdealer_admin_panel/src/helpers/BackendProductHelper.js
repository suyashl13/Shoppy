import axios from "axios"
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
    }).catch(err=>{
        onError({err})
    })
}