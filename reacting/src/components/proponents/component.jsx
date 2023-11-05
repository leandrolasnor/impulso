import React, { useState } from 'react'
import { Container, Row, Col, Button } from "react-bootstrap";
import FormProponent from "./form_create_proponent";
import Report from "./report";
import Grid from './grid'
import styled from 'styled-components'

const OpaqueContainer = styled(Container)`
  background-color: rgba(0, 0, 0, 0.08)
`
const OpaqueRow = styled(Row)`
  background-color: rgba(0, 0, 0, 0.07)
`

const Proponents = () => {
  const [showProponentForm, setShowProponentForm] = useState(false);
  const [showReport, setShowReport] = useState(false);

  return(
    <OpaqueContainer className="pt-2 pb-2" lg={12} md={12} sm={12} xs={12}>
      <Row>
        <Col className="mb-2" lg={1}>
          <Button variant="outline-success" onClick={() => setShowProponentForm(true)}>Hire!</Button>
        </Col>
        <Col className="mb-2" lg={1}>
          <Button variant="outline-info" onClick={() => setShowReport(true)}>Report</Button>
        </Col>
      </Row>
      <OpaqueRow>
        <Grid />
      </OpaqueRow>
      <FormProponent title="New" subtitle="Proponent" show={showProponentForm} handleClose={() => setShowProponentForm(false)} />
      <Report title="Report" subtitle="Proponents" show={showReport} handleClose={() => setShowReport(false)} />
    </OpaqueContainer>
  )
}

export default Proponents
