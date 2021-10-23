import React, { useContext } from 'react'
import SubdealerListTile from '../../components/subdealer/SubdealerListTile'
import { SubdealerContext } from '../../contexts/SubdealerContext'

export default function SubdealerPage() {

    const { subdealerList } = useContext(SubdealerContext)

    return (
        <div className='container mt-5'>
            <h2>Subdealers</h2>
            <hr />
            <list-group>
                {subdealerList?.map((subdealer, index) => <SubdealerListTile key={index} subdealer={subdealer} />)}
            </list-group>
        </div>
    )
}
