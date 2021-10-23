import React from 'react'

export default function CategoryList({ categories }) {
    return (
        <div className='row'>

            {
                categories?.map((element, index) => <div className="col-sm-12 col-md-6 col-lg-4 mb-3" key={index}>
                    <div className='card border'>
                        <div className="card-header">
                            <center className='fw-bold'>{element?.name}</center>
                        </div>
                        <img src={element?.display_url} className='card-img-top' alt="" />
                        <button className='btn btn-info btn-md'>Activate</button>
                    </div></div>)
            }
        </div>
    )
}
