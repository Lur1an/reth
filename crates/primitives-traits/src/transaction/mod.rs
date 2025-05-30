//! Transaction abstraction

pub mod execute;
pub mod signature;
pub mod signed;

pub mod error;
pub mod recover;

pub use alloy_consensus::transaction::{TransactionInfo, TransactionMeta};

use crate::{InMemorySize, MaybeCompact, MaybeSerde};
use core::{fmt, hash::Hash};

#[cfg(test)]
mod access_list;

/// Helper trait that unifies all behaviour required by transaction to support full node operations.
pub trait FullTransaction: Transaction + MaybeCompact {}

impl<T> FullTransaction for T where T: Transaction + MaybeCompact {}

/// Abstraction of a transaction.
pub trait Transaction:
    Send
    + Sync
    + Unpin
    + Clone
    + fmt::Debug
    + Eq
    + PartialEq
    + Hash
    + alloy_consensus::Transaction
    + InMemorySize
    + MaybeSerde
{
}

impl<T> Transaction for T where
    T: Send
        + Sync
        + Unpin
        + Clone
        + fmt::Debug
        + Eq
        + PartialEq
        + Hash
        + alloy_consensus::Transaction
        + InMemorySize
        + MaybeSerde
{
}
