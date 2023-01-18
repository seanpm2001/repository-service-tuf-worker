"""Initial Migration

Revision ID: fceea57e6a38
Revises: 
Create Date: 2023-01-05 10:54:47.399435

"""
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

from alembic import op

# revision identifiers, used by Alembic.
revision = "fceea57e6a38"
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table(
        "rstuf_targets",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("path", sa.String(), nullable=False),
        sa.Column(
            "info", postgresql.JSON(astext_type=sa.Text()), nullable=False
        ),
        sa.Column("rolename", sa.String(), nullable=False),
        sa.Column("published", sa.Boolean(), nullable=False),
        sa.Column(
            "action",
            sa.Enum("ADD", "REMOVE", name="targetaction"),
            nullable=False,
        ),
        sa.Column("last_update", sa.DateTime(), nullable=False),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(
        op.f("ix_rstuf_targets_id"), "rstuf_targets", ["id"], unique=False
    )
    op.create_index(
        op.f("ix_rstuf_targets_path"), "rstuf_targets", ["path"], unique=True
    )
    # ### end Alembic commands ###


def downgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_index(op.f("ix_rstuf_targets_path"), table_name="rstuf_targets")
    op.drop_index(op.f("ix_rstuf_targets_id"), table_name="rstuf_targets")
    op.drop_table("rstuf_targets")
    # ### end Alembic commands ###