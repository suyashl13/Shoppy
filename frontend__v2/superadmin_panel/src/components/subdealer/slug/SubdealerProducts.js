import React from 'react'
import { Link } from 'react-router-dom'

export default function SubdealerProducts({ products }) {
    return (
        products?.length == 0 ?
            <center className='m-5 p-4'> <h4 className='text-muted'>No products.</h4> </center>
            : <div className='list-group'>
                {products?.map((product, index) => <SubdealerProductTile key={index} product={product}
                />)}
            </div>
    )
}

export const SubdealerProductTile = ({ product, children }) => {
    return <Link className="list-group-item d-flex flex-row justify-content-between" to={'/products/' + product?.id}>
        <div className="d-flex flex-column" style={{ width: '60%' }}>
            <h5>{product?.title} (Rs.{product.price})</h5>
            <div>
                <p>{product?.description} <br />
                    {children}
                </p>
            </div>
        </div>
        <div className='image-parent'>
            <img src={product?.product_image} className='img-fluid' alt={product?.title} />
        </div>
    </Link>
}