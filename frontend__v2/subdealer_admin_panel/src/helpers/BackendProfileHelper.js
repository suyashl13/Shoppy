import axios from "axios"
import { BASE_URL } from "../Config"

export const getSubdealerProfile = async ({onSuccess, onError}) => {
    await axios({
        url: `${BASE_URL}users/subdealers/${localStorage.getItem('jwt').split('.')[0]}/`,
        method: 'GET',
        headers: {Authorization : localStorage.getItem('jwt')}
    }).then(
        (e) => {
            onSuccess(e.data);
        }
    ).catch(err=>{
        onError(err)
    })
}