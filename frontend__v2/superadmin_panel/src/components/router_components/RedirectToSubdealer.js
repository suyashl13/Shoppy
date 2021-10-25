import React, { useContext } from 'react'
import { Redirect, useParams } from 'react-router'
import { SubdealerContext } from '../../contexts/SubdealerContext'

export default function RedirectToSubdealer() {

    const { subdealerList } = useContext(SubdealerContext)
    const { redirect_user_id } = useParams()

    const redirectSubdealer = subdealerList?.filter(e => e.user.id == redirect_user_id)[0]

    if (!redirectSubdealer) {
        return <div className='container'>
            <div className="mt-4 rounded bg-warning p-5">
                <h2>Subdealer Deleted!</h2>
                <hr />
                The subdealer with USER ID : {redirect_user_id} is deleted from Database.
            </div>
        </div>
    } else
        return (<Redirect to={`/subdealer/${redirectSubdealer?.id}`} />)
}
