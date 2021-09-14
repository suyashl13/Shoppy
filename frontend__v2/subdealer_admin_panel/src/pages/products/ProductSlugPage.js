import React, { useContext } from 'react'
import { useParams } from 'react-router'
import { productContext } from '../../contexts/ProductContext';

export default function ProductSlugPage() {

    const { id } = useParams()
    const { product, setProduct } = useContext(productContext)
    const myProduct = product?.products.filter(e=>e.id == id)[0];

    return (
        <div className='container p-4'>
            <h1>{id}</h1>
            {JSON.stringify(myProduct)}
        </div>
    )
}
