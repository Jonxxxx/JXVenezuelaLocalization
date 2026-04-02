//7345 - COT
tableextension 84124 JXVZSalesShipmentHeader extends "Sales Shipment Header"
{
    fields
    {
        field(84100; JXVZPointOfSale; Code[5])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Point of sale',
                        Comment = 'ESP = Punto de venta';
            TableRelation = JXVZPointOfSale;
            ValidateTableRelation = true;
        }

        field(84106; JXVZFiscalType; Code[20])
        {
            //RI = Responsable inscripto, CF = Consumidor final, MO = Monotributista
            //RX = Exento, EXT = Extranjero, NC = No categorizado
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Fiscal type', Comment = 'ESP = "Tipo fiscal"';
            TableRelation = JXVZFiscalType."No.";
        }
    }
}
//7345 - COT END