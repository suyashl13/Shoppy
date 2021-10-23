import axios from "axios";
import { BASE_URL } from "../config";

export const getOrderData = ({ onSuccess, onError }) => {
    const jwt = localStorage.getItem('jwt')

    if (!jwt) {
        onError("Unauthorized");
        return;
    }

    axios({
        url: `${BASE_URL}carts/superuser/`,
        method: 'GET',
        headers: {
            Authorization: jwt
        }
    })
        .then(e => { onSuccess(e) })
        .catch(err => { onError(err) })

}